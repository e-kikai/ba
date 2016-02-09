class Client < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  soft_deletable
  default_scope { without_soft_destroyed }

  has_many :client_tables

  def companies
    client_tables.where("table_name LIKE '%companies%'").first
  rescue
    nil
  end
end
