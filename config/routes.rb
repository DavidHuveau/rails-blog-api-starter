Rails.application.routes.draw do
  devise_for :users
  # devise_for :users, controllers: { sessions: 'users/sessions' }

  namespace :api do
    resources :chickens, only: %i[index]

    namespace :v1 do
      resources :posts
      resources :users, only: %i[show create update destroy]
      resources :sessions, only: %i[create destroy]
    end
  end
end
