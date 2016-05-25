class Import < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }

  paginates_per 10

  belongs_to :csvfile
  has_one    :client_table, through: :csvfile
  has_one    :client,       through: :client_table

  serialize :matching_params, JSON
  serialize :errors_ids,      JSON

  # 項目設定の整理し、設定がされているかチェック
  #
  # @param  [Hash] check_params 入力パラメータ
  # @return [Hash] 整理した項目設定
  def self.import_check(check_params)
    matchings = []
    check_params["table_header"].each do |i, h|
      matchings << {table_header: h, i: i.to_i } if h.present? && check_params["method"][i] == "matching"
    end

    matchings
  end

  # マッチングして保存
  #
  # @return self
  def import
    update!(performed_at: Time.now)

    errors    = []

    klass     = client_table.klass(true)
    ctd       = klass.arel_table

    matchings = Import.import_check(matching_params)

    CSV.foreach(csvfile.path, { :headers => true, encoding: Encoding::SJIS }).with_index(1) do |row, i|
      begin
        next if row.all?(&:blank?) # すべて空白の列は無視

        ### マッチング処理 ###
        match_ids = if matchings.present?
          # マッチングするためのフィルタリング
          values = client_table.filter(matchings.map { |m| [ m[:table_header], row[m[:i]] ] }.to_h)

          if values.has_value? ""
            [] # マッチング条件の値がない(スキップする)
          else
            # AND条件マッチング
            if matching_params["option"]["if"] == "and" || matching_params["option"]["if"].blank?
              res = klass.where(values)
            end

            # OR条件マッチング
            if matching_params["option"]["if"] == "or" || (matching_params["option"]["if"].blank? && res.exists? && matchings.length > 1)
              cond = nil
              values.each do |k, v|
                cond = cond ? cond.or(ctd[k].eq(v)) : ctd[k].eq(v)
              end
              res = klass.where(cond)
            end

            res.limit(10).pluck(:id)
          end
        else
          []
        end

        ### マッチング結果 ###
        status, data = if match_ids.count == 1
          [:match, klass.find(match_ids.first)]
        elsif match_ids.count == 0 && matching_params["option"]["unmatch"] == "new"
          [:new, klass.new]
        elsif match_ids.count == 0
          [:unmatch, nil]
        else
          [:overlap, nil]
        end

        # status = match_ids.to_s

        ### 保存 ###
        if data.present?
          matching_params["table_header"].each do |i, h|
            next if matching_params["table_header"][i].blank?

            # データ格納
            if matching_params["method"][i] == "update" \
               || (matching_params["method"][i] == "save" && data[matching_params["table_header"][i]].blank?) \
               || (matching_params["method"][i] == "matching" && data.new_record? && matching_params["table_header"][i] != "id")
              data[h] = row[i.to_i]
            end
          end

          data.save!
        end
      rescue ActiveRecord::RecordInvalid => e
        status = e.record.errors.messages.map do |k, v|
          v.map { |mes| "#{k} #{mes}" }.join("\n")
        end.join("\n")
      rescue => e
        status = e.message
      end

      errors[i] = status
    end

    ActiveRecord::Base.connection.execute("VACUUM;")

    update!(
      success_num: errors.count(:match),
      unmatch_num: errors.count(:unmatch) + errors.count(:new),
      overlap_num: errors.count(:overlap),
      error_num:   errors.count { |v| v.kind_of?(String) },
      errors_ids:  errors,
      finished_at: Time.now
    )
  rescue => e
    update!(
      error_message: e.message,
      rescued_at:   Time.now
    )
  end
end
