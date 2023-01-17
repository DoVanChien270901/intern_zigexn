Rails.application.routes.draw do
  devise_for :account_users, skip: [:sessions]
  as :account_user do
    get '/login', to: 'devise/sessions#new', as: :new_account_user_session
    get '/register', to: 'devise/registrations#new'
    post '/login', to: 'my_devise/sessions#create', as: :account_user_session
    delete '/logout', to: 'devise/sessions#destroy', as: :destroy_account_user_session
    get '/register/1', to: 'my_devise/registrations#new', as: :new_account_user_registrantion
    post '/register/2/', to: 'my_devise/registrations#create', as: :create1_account_user_registrantion
    get '/register/2/', to: 'my_devise/registrations#show', as: :create_account_user_registrantion
    get '/register/3', to: 'my_devise/confirmations#show', as: :show_account_user_registrantation
    post 'register/3', to: 'my_devise/registrations#my_update', as: :update_account_user_registrantaion
    get '/forgot_password', to: 'devise/passwords#new', as: :new_user_password
    post '/forgot_password', to: 'my_devise/passwords#create', as: :password
    get '/reset_password/', to: 'my_devise/passwords#my_edit', as: :edit_password
    put '/forgot_password/', to: 'my_devise/passwords#update'
    get 'admin/login', to: 'my_devise/sessions#admin_login', as: :admin_login
    post 'admin/login', to: 'my_devise/sessions#do_admin_login', as: :new_admin_session
  end
  get '/jobs/', to: 'jobs#search', as: :search_job
  get '/jobs/favorite', to: 'jobs#favorite'
  post '/favorites/:id', to: 'favorites#create', as: :create_favorite
  get '/jobs/search/', to: 'jobs#search'
  post '/jobs/search/', to: 'jobs#search', as: :search_jobs
  get '/jobs/city/:city', to: 'jobs#search'
  get '/detail/:job_id', to: 'jobs#show'
  get '/jobs/industry/:industry', to: 'jobs#search'
  get '/my/', to: 'users#my', as: :user_my
  get '/apply/', to: 'applies#new'
  post '/confirm', to: 'applies#confirm1', as: :confirm1_apply
  get '/confirm', to: 'applies#confirm2', as: :confirm2_apply
  post '/done', to: 'applies#create', as: :create_apply
  get '/done', to: 'applies#done', as: :done_apply
  get 'my/info', to: 'users#info'
  post 'my/info', to: 'users#update', as: :update_user
  root to: 'jobs#index'
  get '/industrys', to: 'categories#show'
  get 'cities', to: 'cities#show'
  get '/my/favorites', to: 'favorites#index'
  delete '/my/favorites/:id', to: 'favorites#remove'
  get '/history', to: 'histories#index'
  delete '/history/:id', to: 'histories#remove', as: :remove_history
  get 'my/jobs', to: 'jobs#applied'
  get 'admin/applies', to: 'jobs#admin_job', as: :applies_admin
  get 'admin/download', to: 'jobs#admin_job', as: :export_applies
  post 'admin/applies', to: 'jobs#admin_job', as: :admin_job
  get '/suggestions/:keyword', to: 'jobs#spellcheck_solr'
end
