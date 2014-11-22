Rails.application.routes.draw do
  root to: 'visitors#index'
  
  get "/dashboard", to: "dashboards#index", as: :dashboard
  
  devise_scope :user do
    get "sign_in", to: "devise/sessions#new", as: :sign_in
  end

  devise_scope :user do
    get "sign_up", to: "devise/registrations#new", as: :sign_up
  end

  devise_scope :user do
    delete "sign_out", to: "devise/sessions#destroy", as: :sign_out
  end  
  
  devise_for :users
  
  resources :users
  
  resources :dashboard
end
