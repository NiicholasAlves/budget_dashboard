json.extract! expense, :id, :spent_on, :amount, :description, :category_id, :user_id, :created_at, :updated_at
json.url expense_url(expense, format: :json)
