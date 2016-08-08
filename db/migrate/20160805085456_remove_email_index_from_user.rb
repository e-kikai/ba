class RemoveEmailIndexFromUser < ActiveRecord::Migration
  def change
    remove_index :clients, :email
    add_index    :clients, [:email, :soft_destroyed_at], unique: true

    remove_index :bamembers, :email
    add_index    :bamembers, [:email, :soft_destroyed_at], unique: true
  end
end
