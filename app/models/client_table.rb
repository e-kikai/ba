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
  after_create  :create_client_table_after

  def self.create_client_table(params)
    params[:table_name] ||=  "c#{params[:client_id]}_#{Time.now.to_i}"

    table = create!(params)

    ActiveRecord::Base.connection.create_table(table.table_name) do |t|
      t.timestamps null: false
      t.datetime   :deleted_at
    end

    table
  end

  # 会社テーブル初期化
  #
  # @param [Iinteger]     client_id クライアントID
  # @return [ClientTable] 生成した会社テーブル
  def self.init_tables(client_id)
    self.create(client_id: client_id, name: "会社", table_name: "c#{client_id}_companies", company: true)

    # 人テーブル初期化
    # table = self.create(client_id: client_id, name: "人", table_name: "c#{client_id}_people")
    # table.client_columns.create(name: "氏名", column_name: :name, column_type: :string, nochange: true)
  end

  # 子テーブルの初期化
  #
  # @param  [Iinteger]    client_id クライアントID
  # @param  [String]      name テーブル名
  # @return [ClientTable] 生成した子テーブル
  def self.init_child_table(client_id, name)
    self.create(client_id: client_id, name: name, table_name: "c#{client_id}_#{Time.now.strftime('%Y%m%d%H%M%S')}", company: false)
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

    ture
  end

  # 他のclientのテーブル構成を複製
  #
  # @param [Integer] 複製先のclient_id
  def clone_table(client_id)
    clone_name = table_name.sub(/([0-9]+)/, client_id.to_s)
    table      = ClientTable.create(client_id: client_id, name: name, table_name: clone_name)

    client_columns.each do |co|
      column = co.dup
      column.client_table_id = table.id
      column.save
    end
  end

  # 表示用のカラム一覧
  def show_client_columns
    client_columns.where(hidden: false)
  end

  # client_table_dataクラスを取得
  def klass
    # if Object.const_defined? table_name.singularize.camelcase
    #   k = Object.const_get(table_name.singularize.camelcase)
    # end

    client_table = self
    Object.const_set(table_name.singularize.camelcase, Class.new(ActiveRecord::Base) do |klass|
      include ClientTableDataModule
      klass.table_name = client_table.table_name

      # if client_table.company?
      #   client_table.client.child_tables.each do |t|
      #     has_many t.table_name.pluralize.intern, primary_key: :company_id
      #   end
      # else
      #   belongs_to client_table.client.company_table.table_name.singularize.intern, foreign_key: :company_id
      # end

      klass.reset_column_information
    end)
  end

  def datas
    klass.all
  end

  def filter(data)
    client_columns.each do |co|
      if data[co.column_name].present?
        data[co.column_name] = co.type.filter(data[co.column_name])
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

  private

  def create_client_table_before
    self[:table_name] ||=  "c_#{client_id}_#{Time.now.strftime('%Y%m%d%H%M%S')}"

    ActiveRecord::Base.connection.create_table(self[:table_name]) do |t|
      t.timestamps null: false
      t.datetime   :soft_destroyed_at
    end
  end

  def create_client_table_after
    if company?
      client_columns.create(name: "会社名",         column_name: :name,    column_type: :company, order_no: 100)
      client_columns.create(name: "都道府県",       column_name: :pref,    column_type: :pref,    order_no: 200)
      client_columns.create(name: "TEL",            column_name: :tel,     column_type: :tel,     order_no: 300)
      client_columns.create(name: "FAX",            column_name: :fax,     column_type: :tel,     order_no: 400)
      client_columns.create(name: "〒",             column_name: :zip,     column_type: :zip,     order_no: 500)
      client_columns.create(name: "住所",           column_name: :address, column_type: :address, order_no: 600)
      client_columns.create(name: "メールアドレス", column_name: :mail,    column_type: :mail,    order_no: 700)
      client_columns.create(name: "URL",            column_name: :url,     column_type: :url,     order_no: 800)
      client_columns.create(name: "ステータス",     column_name: :status,  column_type: :status,  order_no: 900)
      client_columns.create(name: "ターゲット",     column_name: :target,  column_type: :target,  order_no: 1000)
      client_columns.create(name: "流入経路",       column_name: :influx,  column_type: :influx,  order_no: 1100)
    else
      client_columns.create(name: "#{name}名", column_name: :name,       column_type: :string, order_no: 100)
      client_columns.create(name: "会社ID",    column_name: :company_id, column_type: :id,     order_no: 200)
    end

  end

  def check_name(attributed)
    attributed[:name].blank? || attributed[:column_type].blank?
  end
end
