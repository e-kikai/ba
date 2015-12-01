require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  csv << @csv[:header] + ["matching_id", "エラー"]
  # @csv[:body].each do |b|
  CSV.foreach(@csv[:body_path]) do |d|
    csv << d if d[@csv[:header].length + 1].present?
  end
end

NKF::nkf('--sjis -Lw', csv_str)
