class LineItem < ApplicationRecord
  belongs_to :order
  validates :sku, presence: true
  validates :quantity, numericality: { greater_than: 0 }
end
