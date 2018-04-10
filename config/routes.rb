Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root "static_pages#home"

  get 'auth/facebook/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  resources :requests, only: [:new, :create, :edit, :update]

  resources :sessions, only: [:new]
end
