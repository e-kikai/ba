class ClientColumn < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }

  validates :client_table_id, presence: true
  validates :name,            presence: true
  validates :column_name,     presence: true
  validates :column_type,     presence: true

  validate :type_missmatch

  belongs_to :client_table

  default_scope -> { order(:order_no) }
  scope :show,  -> { where(hidden: false) }

  before_validation :default_column_name
  before_create     :add_client_column
  before_update     :change_client_column
  before_destroy    :destroy_client_column

  # 型のselect用配列取得
  def self.column_types_selector(db_type = nil)
    ColumnTypes.constants.map do |type|
      begin
        klass = ColumnTypes.const_get(type)

        if db_type.blank? || klass.db_type == db_type || ([:string, :text].include?(db_type) && [:string, :text].include?(klass.db_type))
          [klass.label, type.to_s.underscore]
        else
          nil
        end
      rescue
      end
    end.compact
  end

  def type
    ColumnTypes.const_get(column_type.classify)
  rescue
    ColumnTypes::String
  end

  private

  def type_missmatch
    errors.add(:column_type, ": 型が不正です(#{column_type})") unless type
  end

  def default_column_name
   self[:column_name] = column_name.presence || "co_#{Time.now.strftime('%Y%m%d%H%M%S')}_#{rand(999)}"
  end

  def add_client_column
    # ActiveRecord::Base.connection.add_column(client_table.table_name, column_name, db_column_type[:type])
    # ActiveRecord::Base.connection.add_column(client_table.table_name, column_name, :text, default: "", null: false)
    ActiveRecord::Base.connection.add_column(client_table.table_name, column_name, type.db_type)
    ActiveRecord::Base.connection.add_index(client_table.table_name, column_name)
  end

  def change_client_column
    # ActiveRecord::Base.connection.change_column(client_table.table_name, column_name, db_column_type[:type])
    # ActiveRecord::Base.connection.change_column(client_table.table_name, column_name, "#{type.db_type} USING CAST(#{column_name} AS #{type.db_type})")
    # ActiveRecord::Base.connection.change_column(client_table.table_name, column_name, :text)
  end

  def destroy_client_column
    ActiveRecord::Base.connection.remove_column(client_table.table_name, column_name)
  end
end
