Rails.application.routes.draw do

  namespace :api do
    resources :chickens, only: %i[index]
    # namespace :v1 do
    scope module: :v1 do
      resources :posts
    end
  end
end
