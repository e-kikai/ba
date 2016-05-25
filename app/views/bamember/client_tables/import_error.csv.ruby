require 'nkf'

csv_str = CSV.generate do |csv|
  CSV.foreach(@import.csvfile.path, { :headers => false, encoding: Encoding::SJIS }).with_index do |row, i|
    next if row.all?(&:blank?) # すべて空白の列は無視

    if i == 0
      csv << row + ["エラー"]
      next
    end

    next unless status = Array(@import.errors_ids)[i.to_i].presence

    error = case status
    when "overlap";       "重複"
    when "unmatch";       "非マッチ"
    when /^(new|match)$/; ""
    else status
    end

    csv << row + [error] if error.present?
  end
end

NKF::nkf('--sjis -Lw', csv_str)
