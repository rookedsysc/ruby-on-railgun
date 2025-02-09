Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts do
        resources :comments, only: %i[index create]
      end
      resources :comments, only: %i[update destroy]
    end
  end
end
