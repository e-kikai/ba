class ClientTable < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }

  validates :client_id,  presence: true
  validates :name,       presence: true
  validates :table_name, presence: true

  belongs_to :client
  has_many   :client_columns
  accepts_nested_attributes_for :client_columns, allow_destroy: true, reject_if: :check_name

  before_create :create_client_table_before
  # after_create  :create_client_table_after

  # 会社テーブルとデフォルトカラム生成
  #
  # @param [Iinteger]     client_id クライアントID
  # @return [ClientTable] 生成した会社テーブル
  def self.create_company_table(client_id)
    co = self.create(client_id: client_id, name: "会社", table_name: "c#{client_id}_companies", company: true)

    co.client_columns.create(name: "会社名",         column_name: :name,    column_type: :company, order_no: 100)
    co.client_columns.create(name: "都道府県",       column_name: :pref,    column_type: :pref,    order_no: 200)
    co.client_columns.create(name: "TEL",            column_name: :tel,     column_type: :tel,     order_no: 300)
    co.client_columns.create(name: "FAX",            column_name: :fax,     column_type: :tel,     order_no: 400)
    co.client_columns.create(name: "〒",             column_name: :zip,     column_type: :zip,     order_no: 500)
    co.client_columns.create(name: "住所",           column_name: :address, column_type: :address, order_no: 600)
    co.client_columns.create(name: "メールアドレス", column_name: :mail,    column_type: :mail,    order_no: 700)
    co.client_columns.create(name: "URL",            column_name: :url,     column_type: :url,     order_no: 800)
    co.client_columns.create(name: "ステータス",     column_name: :status,  column_type: :status,  order_no: 900)
    co.client_columns.create(name: "ターゲット",     column_name: :target,  column_type: :target,  order_no: 1000)
    co.client_columns.create(name: "流入経路",       column_name: :influx,  column_type: :influx,  order_no: 1100)

    co
  end

  # 子テーブルとデフォルトカラム生成
  #
  # @param  [Iinteger]    client_id クライアントID
  # @param  [String]      name テーブル名
  # @return [ClientTable] 生成した子テーブル
  def self.create_chiid_table(client_id, name)
    ch = self.create(client_id: client_id, name: name, table_name: "c#{client_id}_#{Time.now.strftime('%Y%m%d%H%M%S')}", company: false)

    ch.client_columns.create(name: "#{name}名", column_name: :name,       column_type: :string, order_no: 100)
    ch.client_columns.create(name: "会社ID",    column_name: :company_id, column_type: :id,     order_no: 200)

    ch
  end

  # テーブル構成の複製
  #
  # @param  [Iinteger]    client_id クライアントID
  # @param  [Iinteger]    template_id コピー元のクライアントID
  # @return [boolean]     true
  def self.clone_tables(client_id, template_id)
    temp_client = Client.find(template_id)

    temp_client.client_tables.each do |t|
      t.clone_table(client_id)
    end

    true
  end

  # 他のclientのテーブル構成を複製
  #
  # @param [Integer] 複製先のclient_id
  def clone_table(client_id)
    clone_name = table_name.sub(/([0-9]+)/, client_id.to_s)
    table      = ClientTable.create(client_id: client_id, name: name, table_name: clone_name, company: company)

    client_columns.each do |co|
      column = co.dup
      column.client_table_id = table.id
      column.save
    end
  end

  # 表示用のカラム一覧
  def show_columns
    client_columns.show
  end

  # client_table_dataクラスを取得
  def klass
    client_table = self
    Object.const_set(table_name.singularize.camelcase, Class.new(ActiveRecord::Base) do |klass|
      include ClientTableDataModule
      klass.table_name = client_table.table_name

      klass.reset_column_information
    end)
  end

  def datas
    klass.all
  end

  def filter(data)
    client_columns.each do |co|
      if data[co.column_name].present?
        data[co.column_name] = co.filter(data[co.column_name]).to_s.normalize_charwidth.strip
      end
    end

    data
  end

  # 会社テーブルかどうか
  #
  # @return [Boolean] 会社テーブルならばtrue
  def company?
    company ? true : false
  end

  def company_id_column
    client_columns.find_by(column_name: :company_id)
  end

  # アップロードされたファイルをスプレッドシート展開
  #
  # @param  [string] path              tmpファイルパス
  # @param  [string] original_filename 元ファイル名
  # @return [Spreadseet]               スプレッドシートオブジェクト
  def spreadsheet(path, original_filename)
    case File.extname(original_filename)
    when '.csv'  then Roo::CSV.new(path, csv_options: {encoding: Encoding::SJIS})
    when '.xls'  then Roo::Excel.new(path)
    when '.xlsx' then Roo::Excelx.new(path)
    when '.ods'  then Roo::OpenOffice.new(path)
    else raise "不明なファイルタイプです: #{original_filename}"
    end
  end

  private

  def create_client_table_before
    self[:table_name] ||=  "c_#{client_id}_#{Time.now.strftime('%Y%m%d%H%M%S')}"

    ActiveRecord::Base.connection.create_table(self[:table_name]) do |t|
      t.timestamps null: false
      t.datetime   :soft_destroyed_at
    end
  end

  # def create_client_table_after
  #   if company?
  #     client_columns.create(name: "会社名",         column_name: :name,    column_type: :company, order_no: 100)
  #     client_columns.create(name: "都道府県",       column_name: :pref,    column_type: :pref,    order_no: 200)
  #     client_columns.create(name: "TEL",            column_name: :tel,     column_type: :tel,     order_no: 300)
  #     client_columns.create(name: "FAX",            column_name: :fax,     column_type: :tel,     order_no: 400)
  #     client_columns.create(name: "〒",             column_name: :zip,     column_type: :zip,     order_no: 500)
  #     client_columns.create(name: "住所",           column_name: :address, column_type: :address, order_no: 600)
  #     client_columns.create(name: "メールアドレス", column_name: :mail,    column_type: :mail,    order_no: 700)
  #     client_columns.create(name: "URL",            column_name: :url,     column_type: :url,     order_no: 800)
  #     client_columns.create(name: "ステータス",     column_name: :status,  column_type: :status,  order_no: 900)
  #     client_columns.create(name: "ターゲット",     column_name: :target,  column_type: :target,  order_no: 1000)
  #     client_columns.create(name: "流入経路",       column_name: :influx,  column_type: :influx,  order_no: 1100)
  #   else
  #     client_columns.create(name: "#{name}名", column_name: :name,       column_type: :string, order_no: 100)
  #     client_columns.create(name: "会社ID",    column_name: :company_id, column_type: :id,     order_no: 200)
  #   end
  # end

  def check_name(attributed)
    attributed[:name].blank? || attributed[:column_type].blank?
  end
end
