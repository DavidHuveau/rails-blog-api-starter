Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :chickens, only: %i[index]
      resources :posts
    end
  end
end
