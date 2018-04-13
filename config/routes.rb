Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root "requests#index"

  get 'sponsor_someone', to: "static_pages#home", as: :home
  get 'contact', to: "static_pages#contact", as: :contact
  get 'faq', to: "static_pages#faq", as: :faq

  get 'auth/facebook/callback', to: 'sessions#create'
  get 'auth/twitter/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  resources :requests, only: [:index, :new, :create, :edit, :update, :show] do
    resources :pledges, only: [:new, :create]
    resource :thank_you_screens, only: :show
    resources :manage_pledges, only: [:index]
  end

  resources :pledges, only: [:show, :index] do
    resource :requester_status, only: :update, controller: 'pledges/requester_statuses'
    resource :upload_receipts, only: :create, controller: 'pledges/upload_receipts'
    resource :disputes, only: :create, controller: 'pledges/disputes'
  end

  resource :sessions, only: [:new, :destroy]
  resources :manage_pledges, only: :show

  resources :documents, only: [:destroy]

  resources :thank_you_screens do
    collection do
      get :for_pledging
    end
  end
  
  resources :users, only: [] do
    resources :reports, only: [:create]
  end
end
  