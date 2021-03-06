Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: 'users/sessions' }

  resources :factures do
    collection do
      get :grid
      post :action
    end
    post :validation
  end

  namespace :tools do
    get :index
    get :audit_trail
    get :relancer
    
    post :relancer_do
  end

  root to: 'factures#index'

end
