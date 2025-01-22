Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts do
        resources :comments, only: %i[index create]
      end
      resources :comments, only: %i[update destroy]
      resources :taboo_words, only: [:index, :create, :update, :destroy] do
        collection do
          get :trigram
          get :full_text
        end
        end
      end
    end
  end
end
