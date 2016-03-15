class ClientTableData < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }

  #フィルタ・デフォルト値
  before_validation do |data|
    client_table = self.class.get_client_table

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
    client_table = self.class.get_client_table

    client_table.client_columns.each do |co|
      # 必須チェック
      if co[:presence].present?
        errors.add(co.name, "(#{co.db_column_type[:name]}型)必須") if data[co.column_name].blank?
      end

      # ユニーク(空白とデフォルト値は除外)
      if co[:unique].present? && data[co.column_name].present? && data[co.column_name] != co[:default]
        if self.class.where(co.column_name => data[co.column_name]).where.not(id: data[:id]).exists?
          errors.add(co.name, "(#{co.db_column_type[:name]}型)重複")
        end
      end

      # 型バリデーション
      if co.db_column_type[:valid].present? && data[co.column_name].present?
        unless co.db_column_type[:valid].call(data[co.column_name])
          errors.add(co.name, "(#{co.db_column_type[:name]}型)不正な値")
        end
      end
    end
  end

  def client_column(column_name)
    self.get_client_table.client_columns.find_by(column_name: column_name)
  end

  def self.get_client_table
    ClientTable.find_by(table_name: self.table_name)
  end

  def self.get_klass(client_table_name)
    self.table_name = client_table_name
    reset_column_information
    self
  end

  def self.table_search(params)
    # 検索条件
    sparam       = []
    search_query = {}

    if params[:s].present?
      params[:s].each do |s|
        next if s[:column_name].blank?

        ### 値の整形 ###
        tmp = s[:value].to_s.normalize_charwidth.gsub(/[[:blank:]]+/, ' ').strip

        value = case s[:cond]
        when "present", "blank", "overlap", "unique"
          1
        when "in", "not_in" ,"cont_any", "not_cont_any"
          tmp.split(" ")
        else
          tmp
        end

        next if value.blank?

        unless ["overlap", "unique"].include? s[:cond]
          search_query["#{s[:column_name]}_#{s[:cond]}"] = value
        end

        sparam << { column_name: s[:column_name], cond: s[:cond], value: value }
      end

      ### 検索条件の整形(overlap, unique用)
      params[:s].each do |s|
        if ["overlap", "unique"].include? s[:cond]
          temp_in = search(search_query).result.select(s[:column_name]).where.not(s[:column_name] => "").group(s[:column_name]).having("count(*) > 1").pluck(s[:column_name]) || "XXXXXXXDDEFEFEFGBSRDHJHhdft"

          search_query["#{s[:column_name]}_#{s[:cond] == "overlap" ? "in" : "not_in"}"] = temp_in
        end
      end
    end

    res = search(search_query).result

    # 集計
    sum     = params[:sum] || {}
    sum_res = {}
    sums    = res
    if sum[:methods].present?
      sum[:group].each do |g|
        sums = sums.group(g) if g.present?
      end

      sum_method = sum[:methods].split('__')
      sum_res    = sums.try(sum_method[1], sum_method[0])
    end

    ### 並び順 ###
    order = params[:order] || {}
    order[:column] = order[:column].presence || :id
    order[:type]   = order[:type] == "desc" ? :desc : :asc

    # res = res.order("CASE WHEN #{order[:column]} IS NULL OR #{order[:column]} = '' THEN 1 ELSE 0 END")

    # if oc = self.get_client_table.client_columns.find_by(column_name: order[:column])
    #   res = res.order("CAST(#{order[:column]} as #{oc.db_column_type[:type]}) #{order[:type]}")
    # end

    res = res.order(order[:column] => order[:type]).order(:id)

    [res, sparam, order, sum, sum_res]
  end
end
