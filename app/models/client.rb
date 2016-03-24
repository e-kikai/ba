class Client < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  soft_deletable
  default_scope { without_soft_destroyed }

  has_many :client_tables

  def company_table
    client_tables.find_by(company: true)
  end

  def child_tables
    client_tables.where(company: false)
  end
end
