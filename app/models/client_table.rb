class ClientTable < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }

  validates :client_id,  presence: true
  validates :name,       presence: true
  validates :table_name, presence: true

  belongs_to :client
  has_many   :client_columns
  has_many   :csvfiles
  has_many   :imports,       through: :csvfiles

  has_many :dashboards
  has_many :searchurls

  accepts_nested_attributes_for :client_columns, allow_destroy: true, reject_if: :check_name
  accepts_nested_attributes_for :dashboards, allow_destroy: true
  accepts_nested_attributes_for :searchurls, allow_destroy: true

  before_create :create_client_table_before

  CONDITIONS = { "を含む" => "cont", "を含まない" => "not_cont", "で一致" => "eq", "で一致しない" => "not_eq",
    "から始まる" => "start", "から始まらない" => "not_start", "で終わる" => "end", "で終わらない" => "not_end",
    "空白" => "blank", "空白でない" => "present",
    "のいずれかを含む(空白区切り)" => "cont_any", "のいずれかを含まない(空白区切り)" => "not_cont_any",
    "のいずれかに一致(空白区切り)" => "in", "のいずれか一致しない(空白区切り)" => "not_in",
    "以下" => "lteq", "以上" => "gteq", "より小さい" => "lt", "より大きい" => "gt",
    "重複している" => "overlap", "重複していない" => "unique",
  }

  STRING_CONDITIONS = { "を含む" => "", "を含まない" => "not_cont_any", "で一致" => "in", "で一致しない" => "not_in",
    "から始まる" => "start_any", "から始まらない" => "not_start_any", "で終わる" => "end_any", "で終わらない" => "not_end_any",
  }

  NUM_CONDITIONS = %w(eq not_eq blank present in not_in lteq gteq lt gt overlap unique).map { |v| self::CONDITIONS.rassoc(v) }.compact.to_h

  COND_ARRAYS   = %w(in not_in cont_any not_cont_any start_any not_start_any end_any not_end_any)

  SUM_METHODS   = {'件数' => "count", '合計' => "sum", "最大" => "maximum", "最小" => "minimum", "平均" => "average"}

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
    ch.client_columns.create(name: "BA会社ID",    column_name: :company_id, column_type: :id,     order_no: 200)

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

  # 選択肢用のカラム一覧配列
  def show_columns_selector
    show_columns.map { |co| [co.name, co.column_name] }
  end

  def columns_options
    options = [["BA#{name}ID", "id", {data: { db_type: :id}}]]
    options += show_columns.map do |co|
      [co.name, co.column_name, {data: { db_type: co.db_type}}]
    end
    options += [["登録日時", "created_at", {data: { db_type: :datetime}}], ["変更日時", "updated_at", {data: { db_type: :datetime}}]]
  end

  # client_table_dataクラスを取得
  #
  # @return [ClentTableData] このclient_tableのclient_table_dataクラス
  def klass
    client.reflesh_class if Object.const_defined?(table_name.singularize.camelcase).blank?

    Object.const_get(table_name.singularize.camelcase)
  end

  # client_table_dataクラスを生成
  #
  # @return [ClentTableData] このclient_tableのclient_table_dataクラス
  def make_class
    client_table = self
    Object.const_set(table_name.singularize.camelcase, Class.new(ActiveRecord::Base) do |klass|
      include ClientTableDataModule
      klass.table_name   = client_table.table_name

      # リレーション
      if client_table.company?
        client_table.client.child_tables.each.with_index do |ct, i|
          next unless ct.company_id_column

          klass.has_many ct.table_name.pluralize.intern, foreign_key: :company_id
        end
      else
        if client_table.company_id_column
          klass.belongs_to :company, class_name: company_table.table_name.classify, foreign_key: :company_id
        end
      end

      klass.reset_column_information
    end)

    klass
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

  def client_columns_by_column_name
    client_columns.map do |co|
      [co.column_name, co]
    end.to_h
  end

  private

  def create_client_table_before
    self[:table_name] ||=  "c_#{client_id}_#{Time.now.strftime('%Y%m%d%H%M%S')}"

    ActiveRecord::Base.connection.create_table(self[:table_name]) do |t|
      t.timestamps null: false
      t.datetime   :soft_destroyed_at
    end

    ActiveRecord::Base.connection.add_index self[:table_name], :soft_destroyed_at
  end

  def check_name(attributed)
    attributed[:name].blank? || attributed[:column_type].blank?
  end
end
