Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :levenshtein, only: [:index, :create, :update, :destroy] do
        collection do
          get :search
        end
      end
      resources :trigram, only: [:index, :create, :update, :destroy] do
        collection do
          get :trigram
          get :full_text
          get :grpc
        end
      end
    end
  end
end
