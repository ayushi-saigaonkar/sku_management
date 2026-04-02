class Order < ApplicationRecord
  validates :external_id, :placed_at, presence: true
  has_many :line_items
end
