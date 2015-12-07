class BamembersAddColumnSoftDestory < ActiveRecord::Migration
  def change
    add_column :bamembers, :soft_destroyed_at, :datetime

    add_index  :bamembers, :soft_destroyed_at
  end
end
