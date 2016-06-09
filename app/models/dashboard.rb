class Dashboard < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }
  default_scope -> { order(:order_no) }

  belongs_to :client
end
