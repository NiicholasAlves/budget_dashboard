class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :spent_on, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
