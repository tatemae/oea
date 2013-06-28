Oea::Application.routes.draw do

  devise_for :users

  resources :items do
    resources :item_results
    resources :results, :controller => "item_results"
  end

  #root 'items#index'
  root :to => "default#index"

  post '/items/check_answer', to: 'items#check_answer'

  resources :users

  namespace :api do
    get '/results/:item_id', to: 'results#index'
    post "assessments/create"
    resources :items do
      member do
        post :create_questions
      end
    end
  end

  match '/contact' => 'default#contact', via: [:get, :post]
  match '/about' => 'default#about', via: [:get]
end
