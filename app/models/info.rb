class Info < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }

  belongs_to :client
end
