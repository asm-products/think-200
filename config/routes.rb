Think200::Application.routes.draw do
  resources :expectations

  resources :matchers

  resources :requirements

  resources :apps

  resources :projects

  root "pages#home"    
  get "home", to: "pages#home", as: "home"
  get "inside", to: "pages#inside", as: "inside"
  
    
  devise_for :users
  
  namespace :admin do
    root "base#index"
    resources :users
  end

  ResqueWeb::Engine.eager_load!
  # authenticate(:user) do
  #   mount ResqueWeb::Engine => "/resque"
  # end

  resque_constraint = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end

  constraints resque_constraint do
    # mount Resque::Server, :at => "/admin/resque"
    mount ResqueWeb::Engine => "/resque"
  end
end
