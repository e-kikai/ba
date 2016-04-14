require 'nkf'

ss  = @table.spreadsheet(@csv[:path], @csv[:original_filename])

csv_str = CSV.generate do |csv|
  csv << @csv[:header] + ["matching_id", "エラー"]
  # @csv[:body].each do |b|
  @csv[:result].each do |k, v|
    next if [:new, :match].include? v[0]

    if v[2].blank?
      v[2] = case v[0]
      when :skip;    "マッチ項目が空白"
      when :none;    "マッチしない"
      when :overlap; "重複"
      end
    end

    next unless d = ss.row(k)
    csv << d + [Array(v[1]).join(", "), v[2]]
  end
end

NKF::nkf('--sjis -Lw', csv_str)
