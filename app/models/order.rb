class Order < ApplicationRecord
  validates :external_id, :placed_at, presence: true, uniqueness: true
  has_many :line_items, dependent: :destroy
end
