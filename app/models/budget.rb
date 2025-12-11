class Budget < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :month, presence: true
  validates :limit_amount, numericality: { greater_than: 0 }
end
