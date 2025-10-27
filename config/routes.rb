Rails.application.routes.draw do
  devise_for :users

  get "home/index"
  root "home#index"  # home page

  resources :users

  resources :challenges do
    post "join", on: :member   # 👈 esta línea agrega /challenges/:id/join
  end

  resources :participations
  resources :exercises
  resources :progress_entries
  resources :badges
  resources :user_badges

  # Leaderboard
  get "leaderboard", to: "home#leaderboard", as: :leaderboard

  # health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
