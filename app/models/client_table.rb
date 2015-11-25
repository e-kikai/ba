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
  # after_commit    :klass_refresh

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
    # if Object.const_defined? table_name.classify
    #   tmp = Object.const_get(table_name.classify)
    #
    #   tmp.reset_column_information
    #   tmp
    # else
    #   klass_refresh
    # end

    ClientTableData.get_klass(table_name)
  end

  def datas
    ClientTableData.get_klass(table_name).all
  end

  def klass_refresh
    # tmp_table = self
    #
    # Object.class_eval { remove_const tmp_table.table_name.classify } if Object.const_defined? table_name.classify
    #
    # tmp = Class.new(ActiveRecord::Base) do |k|
    #   client_table = tmp_table
    #
    #   table_name = client_table.table_name
    #
    #   # 論理削除
    #   soft_deletable
    #   default_scope { without_soft_destroyed }
    #
    #   # 手動バリデータ
    #   validate do |data|
    #     client_table.client_columns.each do |co|
    #       if co[:presence].present?
    #           errors.add(co.name, "(#{co.db_column_type[:name]}型)必須") if data[co.column_name].blank?
    #       end
    #
    #       if co[:unique].present? && data[co.column_name].present?
    #           errors.add(co.name, "(#{co.db_column_type[:name]}型)重複") if self.class.exists?(co.column_name => data[co.column_name])
    #       end
    #
    #       if co.db_column_type[:valid].present? && data[co.column_name].present?
    #         errors.add(co.name, "(#{co.db_column_type[:name]}型)不正な値") unless co.db_column_type[:valid].call(data[co.column_name])
    #       end
    #     end
    #   end
    #
    #   #フィルタ・デフォルト値
    #   before_validation do |data|
    #     client_table.client_columns.each do |co|
    #       if co.db_column_type[:filter].present?
    #         data[co.column_name] = co.db_column_type[:filter].call(data[co.column_name])
    #       end
    #
    #       if co[:default].present?
    #         data[co.column_name] = co[:default] if new_record? && data[co.column_name].blank?
    #       end
    #     end
    #   end
    # end
    #
    # Object.const_set(table_name.classify, tmp)
    #
    # tmp.reset_column_information
    # tmp
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
