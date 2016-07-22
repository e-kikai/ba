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
end
