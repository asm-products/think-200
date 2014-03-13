Think200::Application.routes.draw do

  # AJAX API
  post "ajax/queue_status"
  get  'ajax/project_tile'
  post 'retest_project/:id', to: 'projects#retest', as: 'retest_project'  

  # Open resources
  resources :projects do
    get 'export'
  end

  # Partially restricted resources
  resources :apps,         except: [:index, :show]
  resources :requirements, except: [:index, :show]
  resources :expectations, except: [:index, :show]

  # Completed restricted resources
  #resources :spec_runs
  #resources :matchers


  root "pages#home"    
  get  "home",    to: "pages#home", as: "home"
  post 'checkit', to: 'pages#checkit', as: 'checkit'
  
    
  devise_for :users
  
  namespace :admin do
    root "base#index"
    resources :users
  end


  # Resque ######################

  ResqueWeb::Engine.eager_load!

  resque_constraint = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end

  constraints resque_constraint do
    # mount Resque::Server, :at => "/admin/resque"
    mount ResqueWeb::Engine => "/resque"
  end
end
