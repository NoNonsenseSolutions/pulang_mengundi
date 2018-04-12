Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root "static_pages#home"

  get 'auth/facebook/callback', to: 'sessions#create'
  get 'auth/twitter/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  resources :requests, only: [:index, :new, :create, :edit, :update, :show] do
    resources :pledges, only: [:new, :create]
    resource :thank_you_screens, only: :show
    resources :manage_pledges, only: [:index]
  end

  resources :pledges, only: [:show, :index] do
    resource :donor_status, only: :update, controller: 'pledges/donor_statuses'
    resource :requester_status, only: :update, controller: 'pledges/requester_statuses'
  end

  resource :sessions, only: [:new, :destroy]
  resources :manage_pledges, only: :show
  
end
