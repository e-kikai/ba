class Client < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  soft_deletable
  default_scope { without_soft_destroyed }

  has_many :client_tables
  has_many :csvfiles,     through: :client_tables
  has_many :imports,      through: :csvfiles
  # has_many :dashboards

  # accepts_nested_attributes_for :dashboards, allow_destroy: true

  # Deviseを使うと、問答無用でemailがユニーク扱いになる。
  # それだと論理削除した際に再登録できないので、一旦emailに関する検証を削除する
  # https://gist.github.com/brenes/4503386
  _validators.delete(:email)
  _validate_callbacks.each do |callback|
    if callback.raw_filter.respond_to? :attributes
      callback.raw_filter.attributes.delete :email
    end
  end

  # emailのバリデーションを定義し直す
  validates :email, presence: true
  validates_format_of :email, with: Devise.email_regexp, if: :email_changed?
  validates_uniqueness_of :email, scope: :soft_destroyed_at, if: :email_changed?

  def company_table
    client_tables.find_by(company: true)
  end

  def child_tables
    client_tables.where(company: false)
  end

  # クライアント単位でclient_table_dataクラスを再構築
  def reflesh_class
    client_tables.each do |ct|
      ct.make_class
    end
  end

  def self.find_for_authentication(warden_conditions)
    without_soft_destroyed.where(email: warden_conditions[:email]).first
  end
end
