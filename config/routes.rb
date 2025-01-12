# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :ingredients, only: [:index]

      resources :recipes, only: [] do
        collection do
          get :search
        end
      end
    end
  end
end
