Rails.application.routes.draw do
  get "home/index"
  root "home#index"  # home page

  resources :users, only: [:index, :show]
  resources :challenges, only: [:index, :show]
  resources :participations, only: [:index, :show]
  resources :exercises, only: [:index, :show]
  resources :progress_entries, only: [:index, :show]
  resources :badges, only: [:index, :show]
  resources :user_badges, only: [:index, :show]

  # health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
