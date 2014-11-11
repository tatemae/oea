Oea::Application.routes.draw do
  root :to => "default#index"

  devise_for :users

  resources :users do
    resources :assessments, except: [:update, :edit], :controller => "assessments"
  end

  resources :assessments
  resources :assessment_loaders
  resources :assessment_results
  resources :item_results

  get 'saml', to: 'saml#index'
  get 'saml/metadata', to: 'saml#metadata'
  post 'saml/consume', to: 'saml#consume'

  # oembed
  match 'oembed' => 'oembed#endpoint', :via => [:get, :post]

  namespace :api do
    resources :assessments
    resources :assessment_results
    resources :item_results
  end

  match '/proxy' => 'default#proxy', via: [:get, :post]
  match '/contact' => 'default#contact', via: [:get, :post]
  match '/about' => 'default#about', via: [:get]
  match '/take' => 'default#take', via: [:get]
end
