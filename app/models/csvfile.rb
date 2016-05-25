class Csvfile < ActiveRecord::Base
  soft_deletable
  # default_scope { without_soft_destroyed }

  paginates_per 10

  belongs_to :client_table
  has_one    :client,       through: :client_table
  has_many   :imports

  def self.upload(table_id, file)
    file_path = Rails.root.join('tmp').join("#{SecureRandom.urlsafe_base64}.csv")
    FileUtils.mv(file.path, file_path)

    all_num = 0
    CSV.foreach(file_path, { :headers => true, encoding: Encoding::SJIS }) do |row|
      all_num += 1 unless row.all?(&:blank?)
    end

    csvfile = self.create!(
      client_table_id:   table_id,
      path:              file_path.to_s,
      original_filename: file.original_filename,
      all_num:           all_num
    )
  end

  # CSVファイルのヘッダを取得
  def header
    if @header.blank?
      File.open(path, {encoding: Encoding::SJIS}) do |f|
        @header = f.readlines[0].parse_csv.map { |v| v.to_s.normalize_charwidth.strip }
      end
    end

    @header
  end

  # CSVファイルのヘッダを除いた1行目取得
  def first
    if @first.blank?
      File.open(path, {encoding: Encoding::SJIS}) do |f|
        @first = f.readlines[1].parse_csv.map { |v| v.to_s.normalize_charwidth.strip }
      end
    end

    @first
  end

  def exist?
    File.exist?(path)
  end
end
