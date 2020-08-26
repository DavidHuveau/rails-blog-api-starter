Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    resources :chickens, only: %i[index]

    namespace :v1 do
      resources :posts
      resources :users, only: %i[show create update destroy]
    end
  end
end
