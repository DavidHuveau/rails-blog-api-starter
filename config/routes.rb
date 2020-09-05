Rails.application.routes.draw do
  devise_for :users
  # devise_for :users, controllers: { sessions: 'users/sessions' }

  namespace :api do
    resources :chickens, only: %i[index]

    namespace :v1 do
      resources :posts, only: %i[show index]
      resources :users, only: %i[show create update destroy] do
        # /users/:user_id/posts
        resources :posts, only: %i[create update]
      end
      resources :sessions, only: %i[create destroy]
    end
  end
end
