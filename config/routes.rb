Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root "static_pages#home"

  get 'auth/facebook/callback', to: 'sessions#create'
  get 'auth/twitter/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  resources :requests, only: [:new, :create, :edit, :update, :show] do
    resources :pledges, only: [:create]
    resource :bank_details, only: :show
  end

  resources :pledges do
    resource :donor_status, only: :update, controller: 'pledges/donor_statuses'
    resource :requester_status, only: :update, controller: 'pledges/requester_statuses'
  end

  resource :sessions, only: [:new, :destroy]
  
end
