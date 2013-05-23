Oea::Application.routes.draw do

  devise_for :users

  resources :items do
    resources :item_results
  end

  root 'items#index'

  post '/items/check_answer', to: 'items#check_answer'

  namespace :api do
    get '/results/:item_id', to: 'results#index'
    post 'items/create'
  end
end
