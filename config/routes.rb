Oea::Application.routes.draw do

  devise_for :users
  resources :assessments do
    resources :results, :controller => "assessment_results"
    resources :sections do
      resources :items do
        resources :results, :controller => "item_results"
      end
    end
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
    resources :assessments, only: [:index, :create]
  end

  match '/contact' => 'default#contact', via: [:get, :post]
  match '/about' => 'default#about', via: [:get]
end
