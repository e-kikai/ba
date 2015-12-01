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
    params[:table_name] ||=  "c#{client_id}_#{Time.now.to_i}"

    table = create!(params)

    ActiveRecord::Base.connection.create_table(table.table_name) do |t|
      t.timestamps null: false
      t.datetime   :deleted_at
    end

    table
  end

  def self.create_companies(client_id)
    table = self.create(client_id: client_id, name: "会社テーブル", table_name: "c#{client_id}_companies")
    table.client_columns.create(name: "会社名", column_name: :name, column_type: :company, nochange: true)
  end

  def self.create_persons(client_id)
    table = self.create(client_id: client_id, name: "人テーブル", table_name: "c#{client_id}_people")
    table.client_columns.create(name: "氏名", column_name: :name, column_type: :string, nochange: true)
  end

  def self.create_actions(client_id)
    table = self.create(client_id: client_id, name: "アクションテーブル", table_name:  "c#{client_id}_actions")
    table.client_columns.create(name: "アクション名", column_name: :name, column_type: :string, nochange: true)
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

  private

  def create_client_table
    self[:table_name] ||=  "c_#{client_id}_#{Time.now..strftime('%Y%m%d%H%M%S')}_#{rand(99999)}"
    ActiveRecord::Base.connection.create_table(self[:table_name]) do |t|
      t.timestamps null: false
      t.datetime   :soft_destroyed_at
    end
  end

  def check_name(attributed)
    attributed[:name].blank? || attributed[:column_type].blank?
  end
end
