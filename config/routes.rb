Rails.application.routes.draw do
  # Root route → Dashboard
  root "dashboard#index"

  # Devise routes for users
  devise_for :users

  # Resources
  resources :budgets
  resources :expenses
  resources :categories

  # Dashboard explicit route (still okay to keep)
  get "dashboard/index"

  # Optional home page route (not used anymore)
  get "home/index"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
