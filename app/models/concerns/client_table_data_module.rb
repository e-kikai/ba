module ClientTableDataModule
  extend ActiveSupport::Concern

  included do
    @@client_table = nil

    soft_deletable
    default_scope { without_soft_destroyed }

    #フィルタ・デフォルト値
    before_validation do |data|
      client_table = self.class.client_table

      # フィルタ
      data = client_table.filter(data)

      # デフォルト値
      client_table.client_columns.each do |co|
        if co[:default].present?
          data[co.column_name] = co[:default] if new_record? && data[co.column_name].blank?
        end
      end
    end

    # 手動バリデータ
    validate do |data|
      client_table = self.class.client_table

      client_table.client_columns.each do |co|
        # 必須チェック
        if co[:presence].present?
          errors.add(co.name, "(#{co.label}型)必須") if data[co.column_name].blank?
        end

        # ユニーク(空白とデフォルト値は除外)
        if co[:unique].present? && data[co.column_name].present? && data[co.column_name] != co[:default]
          if self.class.where(co.column_name => data[co.column_name]).where.not(id: data[:id]).exists?
            errors.add(co.name, "(#{co.label}型)重複")
          end
        end

        # 型バリデーション
        if data[co.column_name].present?
          unless co.valid(data[co.column_name])
            errors.add(co.name, "(#{co.label}型)不正な値")
          end
        end
      end
    end

    # ransackによる検索
    scope :table_search_02, -> (search_params) {
      # 検索条件の整形
      shaping_params = shaping_params(search_params)

      columns = client_table.client_columns_by_column_name

      search_query = {}
      shaping_params.each do |column_name, s|
        if column_name == "blanks"
          # 空白
          s.each { |co2| search_query["#{co2}_blank"] = true }
        elsif %w(overlaps uniques presents).include? column_name
          # 存在
          s.each do |co2|
            co = columns[co2]
            cond = (!co || co.numeric? || co.datetime?) ? "not_null" : "present"
            search_query["#{co2}_#{cond}"] = true
          end
        elsif column_name == "s"
          search_query[:s] = s # ソート
        else
          # その他,通常のカラム
          s.each do |cond, val|
            search_query["#{column_name}_#{cond}"] = val
          end
        end
      end

      # raise search_query.to_s
      res = search(search_query).result

      # リレーションのincludes
      if client_table.company?
        inc = []
        client_table.client.child_tables.each do |ct|
          inc << ct.table_name.pluralize if ct.company_id_column
        end

        res = res.includes(inc) if inc.present?
      else
        res = res.includes(:company) # if client_table.company_id_column
      end

      ### 重複検索(検索フィルタリング後に行う) ###
      if Hash(search_params)["overlaps"].present?
        overlaps = Array(search_params["overlaps"]).select { |co| columns[co].present? }
        if overlaps.present?
          res = res.where("(#{overlaps.map { |co| "#{client_table.table_name}.#{co}" }.join(',')}) IN (#{res.group(overlaps).having("count(*) > 1").select(overlaps).reorder(overlaps).to_sql})")
        end
      end

      ### ユニーク検索(検索フィルタリング後に行う) ###
      if Hash(search_params)["uniques"].present?
        uniques = Array(search_params["uniques"]).select { |co| columns[co].present? }
        if uniques.present?
          res = res.where("(#{uniques.map { |co| "#{client_table.table_name}.#{co}" }.join(',')}) IN (#{res.group(uniques).having("count(*) = 1").select(uniques).reorder(uniques).to_sql})")
        end
      end

      res
    }

    scope :table_sum, -> (sum_params = []) do
      sum_shaping_params = sum_shaping_params(sum_params)
      tmp = all
      columns = client_table.client_columns_by_column_name

      Array(sum_shaping_params[:axis]).each do |s|
        next if s["column"].blank?

        next unless co = columns[s["column"]]

        if co.numeric?
          sepa = s["sepa"].to_s.split(",").map(&:to_i).uniq.sort.map(&:to_s)

          casewhen = if sepa.blank?
            s["column"]
          else
            sepa.inject(" CASE ") do |s, i|
              s + ActiveRecord::Base.send(:sanitize_sql_array, [" WHEN #{co.column_name} <= ? THEN ? ", "#{i}", "〜 #{i}"])
            end + " ELSE 'それ以上' END "
          end

          tmp = tmp.group(casewhen).where("#{co.column_name} IS NOT NULL")
        else
          tmp = tmp.group(s["column"]).where.not(s["column"] => "")
        end
      end

      tmp.try(sum_shaping_params[:method], sum_shaping_params[:column])
    end

    # PostgreSQLでの型キャスト
    scope :cast, -> (str, type) {
      Arel::Nodes::NamedFunction.new(
        'CAST', [
          Arel::Nodes::As.new(
            Arel::Nodes.build_quoted(str),
            Arel::Nodes::SqlLiteral.new(type)
          )
        ]
      )
    }

    scope :presents, -> (column_name) { where(cast(arel_table[column_name], "TEXT").not_eq("")) }

    scope :rfm, -> (rfm_parmas) {
      companies_sql = select("company_id, #{rfm_parmas["x_select"]} as ax, #{rfm_parmas["y_select"]} as ay")
        .where.not(company_id: nil, rfm_parmas["x_column"] => nil, rfm_parmas["y_column"] => nil).group(:company_id).to_sql

      x_case = rfm_parmas[:x_sepa].split(",").inject(" CASE ") do |s, i|
        s + ActiveRecord::Base.send(:sanitize_sql_array, [" WHEN cs.ax <= ? THEN ? ", "#{i} #{rfm_parmas["x_date"]}", "#{i}"])
      end + " ELSE 'more' END "

      y_case = rfm_parmas[:y_sepa].split(",").inject(" CASE ") do |s, i|
        s + ActiveRecord::Base.send(:sanitize_sql_array, [" WHEN cs.ay <= ? THEN ? ", "#{i} #{rfm_parmas["y_date"]}", "#{i}"])
      end + " ELSE 'more' END "

      sql = "SELECT  #{x_case} AS x, #{y_case} AS y, count(*) as count, string_agg(CAST(company_id AS TEXT), ' ') as company_ids
        FROM (#{companies_sql}) cs GROUP BY x, y ORDER BY x, y;"

      find_by_sql(sql)
    }
  end

  def client_column(column_name)
    self.client_table.client_columns.find_by(column_name: column_name)
  end

  class_methods do
    def client_table
      # @@client_table ||= ClientTable.find_by(table_name: self.table_name)
      ClientTable.find_by(table_name: self.table_name)
    end

    def company_table
      client_table.client.company_table
    end

    # リレーション
    def relation_matching(relations = {})
      raise "リレーション対象を選択して下さい1" if relations.blank?

      ch = arel_table
      co = company_table.klass.arel_table

      jo = nil
      relations.each do |r|
        next if r[:child_column].blank? || r[:company_column].blank?
        tmp = cast(ch[r[:child_column]], "TEXT").eq(cast(co[r[:company_column]], "TEXT"))
        jo = jo.blank? ? tmp : jo.and(tmp)
        jo = jo.and(cast(co[r[:company_column]], "TEXT").not_eq(""))
      end

      raise "リレーション対象を選択して下さい2" if jo.blank?

      res = joins(ch.join(co, Arel::Nodes::OuterJoin).on(jo).join_sources).where(ch[:company_id].eq(nil)).where(co[:soft_destroyed_at].eq(nil))
      res.pluck(:id, company_table.table_name + ".id").group_by{|i| i[0]}
    end

    # 一括削除
    #
    # @param  [Hash]    search_params 検索条件パラメータ
    # @return [Integer] 削除件数
    def bulk_destroy(bulk_method, search_params)
      shaping_params = shaping_params(search_params)
      datas          = table_search_02(shaping_params)

      case bulk_method
      when "destroy"
        transaction do
          datas.update_all(soft_destroyed_at: Time.now)
        end
      when "overlaps"
        raise "重複条件が設定されていません" if shaping_params["overlaps"].blank?
        delcount = 0

        transaction do
          overlap_datas = datas.group(shaping_params["overlaps"]).select(shaping_params["overlaps"])

          overlap_datas.each do |od|
            res = datas.where(od.attributes.reject { |k, v| v.blank? }).order(:id)

            # 一番最初に登録されたものを残して一括削除
            tmp = res.first
            delcount += res.update_all(soft_destroyed_at: Time.now)
            tmp.restore!
            delcount -= 1
          end
        end
        delcount
      else
        raise "処理が選択されていません"
      end
    end

    # 検索条件を整形
    def shaping_params(search_params)
      columns = client_table.client_columns_by_column_name
      res = {}

      Hash(search_params).each do |column_name, s|
        if s.is_a? Hash
          co = columns[column_name] # 検索対象のカラム情報

          # value, cond
          conds = s.key?("v") ? {(s["c"].presence || "cont_any") => s["v"]} : s

          res[column_name] = conds.map do |cond, val|
            ### 値の整形 ###
            unless val.is_a? Array
              val = val.to_s.normalize_charwidth.gsub(/[[:blank:]]+/, ' ').strip
              val = val.split(" ") if ClientTable::COND_ARRAYS.include? cond
            end

            # フィルタリング
            if val.is_a? Array
              [cond, Array(val).map { |v| co.try(:filter, v) || v }]
            else
              [cond, co.try(:filter, val) || val]
            end
          end.to_h
        else
          # 空白・重複・ソート
          # res[column_name] = Array(s).select { |co2| columns[co2].present? }
          res[column_name] = Array(s)
        end
      end

      res
    end

    def sum_shaping_params(sum_params)
      # 旧仕様URL対応
      res = if sum_params.is_a? Array
         { axis: Array(sum_params) }
      else
         Hash(sum_params).dup
      end

      res[:method] = :count unless ClientTable::SUM_METHODS.value? res[:method]

      res
    end

    # 検索条件を整形
    def rfm_shaping_params(rfm_params)
      res = {}
      rfm_params = Hash(rfm_params)

      rfm_params.select { |k, v| k =~ /^hot_/ }.each do |k, v|
        res[k] = v.to_s
      end

      res[:x_sepa] = rfm_params[:x_sepa].to_s.split(",").map(&:to_i).uniq.sort.map(&:to_s).join(", ").presence || "3, 6, 9, 12, 15, 18, 21, 24"
      res[:y_sepa] = rfm_params[:y_sepa].to_s.split(",").map(&:to_i).uniq.sort.map(&:to_s).join(", ").presence || "1, 2, 3, 4, 6, 10, 15, 20, 30"

      [:x, :y].each do |key|
        key_res = case rfm_params[key]
        when /^(.*)__(.*)__(.*)$/
          co = client_table.client_columns.find_by(column_name: $1)

          case
          when co.datetime?
            key_select = "CURRENT_DATE - CAST(#{$3 == "min" ? "MIN" : "MAX"}(#{$1}) AS TIMESTAMP)"
            case $2
            when "day"
              [rfm_params[key], "日",   "DAY",   key_select, $1]
            when "year"
              [rfm_params[key], "年",   "YEAR",  key_select, $1]
            else
              [rfm_params[key], "ヶ月", "MONTH", key_select, $1]
            end
          when co.numeric?
            func = (["sum", "max", "min", "avg"].include? $3) ? $3 : "MAX"
            [rfm_params[key], ($2 == "yen" ? "円" : ""), "", "#{func}(#{$1})", $1]
          end
        else
          ["count", "回", "", " count(*) ", "company_id"]
        end

        res.merge!({
          "#{key}"        => key_res[0],
          "#{key}_unit"   => key_res[1],
          "#{key}_date"   => key_res[2],
          "#{key}_select" => key_res[3],
          "#{key}_column" => key_res[4],
        })
      end

      res
    end

  end
end
