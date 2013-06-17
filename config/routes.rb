Oea::Application.routes.draw do

  devise_for :users

  resources :items do
    resources :item_results
    resources :results, :controller => "item_results"
    resources :raw_results
  end

  root 'items#index'

  post '/items/check_answer', to: 'items#check_answer'

  namespace :api do
    get '/results/:item_id', to: 'results#index'
    resources :items do
      member do
        post :create_questions
      end
    end
  end
end