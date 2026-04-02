class SkuStat < ApplicationRecord
  validates :sku, :week, presence: true
  validates :total_quantity, presence: true
end
