class Searchurl < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }
  default_scope -> { order(:order_no) }

  belongs_to :client_table

  serialize :query, JSON

  ACTION_SELECTOR = {"集計" => "sum", "検索" => "search", "RFM" => "rfm"}
end
