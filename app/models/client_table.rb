class ClientTable < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }

  validates :client_id,  presence: true
  validates :name,       presence: true
  validates :table_name, presence: true

  belongs_to :client
  has_many   :client_columns
  accepts_nested_attributes_for :client_columns, allow_destroy: true, reject_if: :check_name

  before_create   :create_client_table

  def self.create_client_table(params)
    params[:table_name] ||=  "c#{params[:client_id]}_#{Time.now.to_i}"

    table = create!(params)

    ActiveRecord::Base.connection.create_table(table.table_name) do |t|
      t.timestamps null: false
      t.datetime   :deleted_at
    end

    table
  end

  def self.init_tables(client_id)
    # 会社テーブル初期化
    table = self.create(client_id: client_id, name: "会社", table_name: "c#{client_id}_companies")
    table.client_columns.create(name: "会社名", column_name: :name, column_type: :company, nochange: true)

    # 人テーブル初期化
    # table = self.create(client_id: client_id, name: "人", table_name: "c#{client_id}_people")
    # table.client_columns.create(name: "氏名", column_name: :name, column_type: :string, nochange: true)
  end

  def self.init_child_table(client_id)

  end

  def self.clone_tables(client_id, template_id)
    temp_client = Client.find(template_id)

    temp_client.client_tables.each do |t|
      t.clone_table(client_id)
    end
  end

  def clone_table(client_id)
    # テーブル複製
    clone_name = table_name.sub(/([0-9]+)/, client_id.to_s)
    table      = ClientTable.create(client_id: client_id, name: name, table_name: clone_name)

    # カラム複製
    client_columns.each do |co|
      column = co.dup
      column.client_table_id = table.id
      column.save
    end
  end

  def show_client_columns
    client_columns.where(hidden: false)
  end

  def klass
    ClientTableData.get_klass(table_name)
  end

  def datas
    ClientTableData.get_klass(table_name).all
  end

  def filter(data)
    client_columns.each do |co|
      if co.db_column_type[:filter].present? && data[co.column_name].present?
        data[co.column_name] = co.db_column_type[:filter].call(data[co.column_name])
      end
    end

    data
  end

  def companies?
    table_name =~ /companies/ ? true : false
  end

  private

  def create_client_table
    self[:table_name] ||=  "c_#{client_id}_#{Time.now.strftime('%Y%m%d%H%M%S')}_#{rand(99999)}"

    ActiveRecord::Base.connection.create_table(self[:table_name]) do |t|
      t.timestamps null: false
      t.datetime   :soft_destroyed_at
    end
  end

  def check_name(attributed)
    attributed[:name].blank? || attributed[:column_type].blank?
  end
end
