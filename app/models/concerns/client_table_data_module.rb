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

    # リレーション結果取得
    scope :company_relation, -> {
      if client_table.company?
        co = arel_table

        tmp = select(co[Arel.star])
        client_table.client.child_tables.each.with_index do |child_table, i|
          next unless child_table.company_id_column

          child_column = "#{child_table.table_name}_count"
          child_as     = "r_#{i.to_s}"
          ch = child_table.klass.arel_table

          ch_count = ch.project(ch[:id].count.as(child_column), ch[:company_id]).group(ch[:company_id]).as(child_as)
          tmp = tmp.joins(co.join(ch_count, Arel::Nodes::OuterJoin).on(co[:id].eq(ch_count[:company_id])).join_sources)
            .select(ch_count[child_column])
        end
        tmp
      else
        if client_table.company_id_column
          ch = arel_table
          co = company_table.klass.arel_table.alias('company')

          joins(ch.join(co, Arel::Nodes::OuterJoin).on(ch[:company_id].eq(co[:id])).join_sources)
            .select(ch[Arel.star], co[:name].as("company_name"))
        else
          self
        end
      end
    }

    # ransackによる検索
    scope :table_search, -> (search_params) {
      search_query = {}
      Array(search_params).each do |s|
        next if s[:column_name].blank? || s[:cond].blank? || ["overlap", "unique", "present", "blank"].include?(s[:cond])

        ### 値の整形 ###
        value = s[:value].to_s.normalize_charwidth.gsub(/[[:blank:]]+/, ' ').strip
        value = value.split(" ") if %w(in not_in cont_any not_cont_any).include? s[:cond]

        if co = client_table.client_columns.find_by(column_name: s[:column_name])
          value = if %w(in not_in cont_any not_cont_any).include? s[:cond]
            value.map { |v| co.filter(v) }
          else
            co.filter(value)
          end
        end

        if value.present?
          search_query["#{s[:column_name]}_#{s[:cond]}"] = value
        end
      end

      ### 重複検索(検索フィルタリング後に行う) ###
      Array(search_params).each do |s|
        if (["present", "blank"].include? s[:cond])
          search_query["#{s[:column_name]}_#{s[:cond]}"] = true
        end

        if ["overlap", "unique"].include? s[:cond]
          temp_in = search(search_query).result.select(s[:column_name])
          .where.not(s[:column_name] => "")
          .group(s[:column_name]).having("count(*) > 1")
          .pluck(s[:column_name])

          search_query["#{s[:column_name]}_#{s[:cond] == "overlap" ? "in" : "not_in"}"] = temp_in.presence || "xxxnoaxxx"
        end
      end

      search(search_query).result
    }

    scope :table_order, -> (order_params) {
      if order_params.present?
        column = order_params[:column].presence || :id
        type   = order_params[:type] == "desc" ? :desc : :asc

        order(column => type)
      end
    }

    scope :table_sum, -> (sum_params = {}) do
      tmp = self

      Array(sum_params).each do |s|
        next if s[:column].blank?

        next unless co = client_table.client_columns.find_by(column_name: s[:column])

        if ["integer", "float", "yen"].include?(co.column_type)
          sepa = s[:sepa].to_s.split(",").map(&:to_i).uniq.sort.map(&:to_s)

          casewhen = if sepa.blank?
            s[:column]
          else
            sepa.inject(" CASE ") do |s, i|
              s + ActiveRecord::Base.send(:sanitize_sql_array, [" WHEN #{co.column_name} <= ? THEN ? ", "#{i}", "〜 #{i}"])
            end + " ELSE 'それ以上' END "
          end

          tmp = tmp.group(casewhen).where("#{co.column_name} IS NOT NULL")
        else
          tmp = tmp.group(s[:column]).where.not(s[:column] => "")
        end
      end

      tmp
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
  end

  def client_column(column_name)
    self.client_table.client_columns.find_by(column_name: column_name)
  end

  class_methods do
    def client_table
      @@client_table ||= ClientTable.find_by(table_name: self.table_name)
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

  end
end
