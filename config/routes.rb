Oea::Application.routes.draw do
  root :to => "default#index"

  devise_for :users

  resources :users do
    member do
      get :reset_authentication_token
    end
    resources :assessments, except: [:update, :edit], :controller => "assessments"
  end

  resources :assessments, except: [:update, :edit] do
    get 'results', on: :member, to: 'assessment_results#index'
    resources :sections, except: [:update, :edit] do
      resources :items, except: [:update, :edit] do
        get 'results', on: :member, to: 'item_results#index'
      end
    end
  end

  post '/items/check_answer', to: 'items#check_answer'

  namespace :api do
    resources :items, only: [:index] do
      get 'results', on: :member, to: 'item_results#index'
    end
    resources :assessments, except: [:update, :new, :edit] do
      get 'results', on: :member
      resources :items, only: [:index]
      resources :sections, except: [:update, :new, :edit] do
        resources :items, except: [:update, :new, :edit], shallow: true
      end
    end
  end

  match '/contact' => 'default#contact', via: [:get, :post]
  match '/about' => 'default#about', via: [:get]
  match '/take' => 'default#take', via: [:get]
end
