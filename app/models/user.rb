class User < ApplicationRecord
  # Devise modules (already present)
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # add associations
  has_many :categories, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :budgets, dependent: :destroy
end

