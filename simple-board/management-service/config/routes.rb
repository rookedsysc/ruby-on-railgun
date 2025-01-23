Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :levenshtein, only: [:index, :create, :update, :destroy] do
        collection do
          get :search
        end
      end
    end
  end
end
