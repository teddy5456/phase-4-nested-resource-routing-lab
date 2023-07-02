Rails.application.routes.draw do
  resources :users, only: [:show] do
    resources :items, except: [:edit, :update, :destroy]
  end

  resources :items, only: [:index]
end
