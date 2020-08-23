Rails.application.routes.draw do
  devise_for :users

# Api definition
  namespace :api do
    resources :chickens, only: %i[index]

    namespace :v1 do
      resources :posts
      resources :users, only: %i[show]
    end
  end
end
