Rails.application.routes.draw do

  devise_for :users
  namespace :api do
    resources :chickens, only: %i[index]

    namespace :v1 do
      resources :posts
    end
  end
end
