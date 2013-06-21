Oea::Application.routes.draw do

  get "assessments/index"
  get "assessments/create"
  devise_for :users

  resources :items do
    resources :item_results
    resources :results, :controller => "item_results"
    resources :raw_results
  end

  #root 'items#index'
  root :to => "default#index"

  post '/items/check_answer', to: 'items#check_answer'

  resources :users

  namespace :api do
    get '/results/:item_id', to: 'results#index'
    resources :items do
      member do
        post :create_questions
      end
    end
  end

  match '/contact' => 'default#contact', via: [:get, :post]
  match '/about' => 'default#about', via: [:get]
end