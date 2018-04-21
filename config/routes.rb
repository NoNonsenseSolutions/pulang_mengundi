# frozen_string_literal: true

class RouteConstraint
  EXCLUDED_ROUTES = I18n.available_locales + [:rails]
end



Rails.application.routes.default_url_options[:host] = ENV['HOST_URL']

Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'administrator/sessions',
    passwords: 'administrator/passwords',
  }
  devise_for :users, skip: :all

  namespace :administrator do
    root 'users#index'

    resources :admins, only: %i[new create index]
    resources :requests, only: %i[index edit update show]
    resources :users, only: %i[index]
  end

  scope '/:locale', locale: /#{I18n.available_locales.join("|")}/ do

    root 'requests#index'

    get 'sponsor_someone', to: 'static_pages#home', as: :home
    get 'contact', to: 'static_pages#contact', as: :contact
    get 'faq', to: 'static_pages#faq', as: :faq

    get 'auth/:provider/localized', to: 'sessions#localized', as: :omniauth_localized

    resources :requests, only: %i[index new create edit update show] do
      resources :pledges, only: %i[new create]
      resource :thank_you_screens, only: :show
      resources :manage_pledges, only: [:index]
      resource :enables, only: :create, controller: 'requests/enables'
      resource :disables, only: :create, controller: 'requests/disables'
    end

    resources :pledges, only: %i[show index] do
      resource :requester_status, only: :update, controller: 'pledges/requester_statuses'
      resource :upload_receipts, only: :create, controller: 'pledges/upload_receipts'
      resource :disputes, only: :create, controller: 'pledges/disputes'
    end

    resources :completed_requests, only: [:index]

    resource :sessions, only: %i[new destroy]
    resources :manage_pledges, only: :show

    resources :documents, only: [:destroy]

    resources :thank_you_screens do
      collection do
        get :for_pledging
      end
    end

    resource :profiles, only: %i[edit update]

    resources :users, only: [] do
      resources :reports, only: [:create]
    end

    resources :email_confirmations, only: [:show]

    resource :terms_and_conditions, only: [:show, :update]
  end

  # omniauth out of scope, as omniauth does not support dynamic paths
  get 'auth/facebook/callback', to: 'sessions#create'
  get 'auth/twitter/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  root to: redirect("/#{I18n.default_locale}", status: 302), as: :redirected_root



  get '/*path', to: redirect("/#{I18n.default_locale}/%{path}", status: 302),
    constraints: { path: /(?!(#{RouteConstraint::EXCLUDED_ROUTES.join("|")})\/).*/ },
    format: false
end
