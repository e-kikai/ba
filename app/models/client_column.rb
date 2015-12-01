class ClientColumn < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }

  validates :client_table_id, presence: true
  validates :name,            presence: true
  validates :column_name,     presence: true
  validates :column_type,     presence: true

  validate :type_missmatch

  belongs_to :client_table

  scope :show, -> { where(hidden: false) }

  before_validation :default_column_name
  before_create     :add_client_column
  before_update     :change_client_column
  before_destroy    :destroy_client_column

  COLUMN_TYPES = {
    string:  { name: "文字列",   type: :string},
    text:    { name: "テキスト", type: :text},
    integer: {
      name:  "整数",
      type:  :integer,
      valid: -> (v) { Integer(v) rescue false },
      # validates: { numericality: { only_integer: true, allow_blank: true } },
    },
    float: {
      name:  "小数",
      type:  :float,
      valid: -> (v) { Float(v) rescue false },
      # validates: { numericality: true },
    },
    company:   {
      name:   "会社名",
      type:   :string,
      filter: -> (v) { v.gsub(/\(株\)|（株）|㈱/, "株式会社").gsub(/\(有\)|（有）|㈲/, "有限会社") }
    },
    tel:       {
      name:  "TEL",
      type:  :string,
      valid: -> (v) { v =~ /\A[0-9+-]*\z/ },
      # validates: { length: { maximum: 255 }, format: { with: /\A[0-9+-]*\z/ } },
    },
    mail:      {
      name:  "メールアドレス",
      type:  :string,
      valid: -> (v) { v =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
      # validates: { length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i } }
    },

    # selector:  { name: "選択(単数)", type: :text},
    # selectors: { name: "選択(複数)", type: :text},
  }

  def db_column_type
    COLUMN_TYPES[column_type.intern] || {}
  end

  private

  def type_missmatch
    errors.add(:column_type, ": 型が不正です(#{column_type})") unless db_column_type
  end

  def default_column_name
   self[:column_name] = column_name.presence || "co_#{Time.now.strftime('%Y%m%d%H%M%S')}_#{rand(99999)}"
  end

  def add_client_column
    # ActiveRecord::Base.connection.add_column(client_table.table_name, column_name, db_column_type[:type])
    ActiveRecord::Base.connection.add_column(client_table.table_name, column_name, :text, default: "", null: false)
    ActiveRecord::Base.connection.add_index(client_table.table_name, column_name)
  end

  def change_client_column
    # ActiveRecord::Base.connection.change_column(client_table.table_name, column_name, db_column_type[:type])
    ActiveRecord::Base.connection.change_column(client_table.table_name, column_name, :text)
  end

  def destroy_client_column
    # ActiveRecord::Base.connection.remove_column(client_table.table_name, column_name)
  end
end
