Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    get "/users/service", to: "users#service"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  api_version(:module => "V1", :path => {:value => "v1"}) do

    get '/actuals/delete', to: 'actuals#delete'
    get '/profiles/search', to: 'profiles#search'
    put '/profiles', to: 'profiles#update'
    get '/profiles/my', to: 'profiles#my'
    post '/profiles/add_experties/:id', to: 'profiles#add_experties'
    post '/profiles/remove_experties/:id', to: 'profiles#remove_experties'

    post '/tasks/involvements', to: 'tasks#add_involvements'
    get '/tasks/involvements/delete', to: 'tasks#remove_involvements'
    post '/tasks/group_involvements', to: 'tasks#add_group_involvements'
    get '/tasks/group_involvements/delete', to: 'tasks#remove_group_involvements'
    post '/tasks/status', to: 'tasks#change_status'
    post '/tasks/change_role', to: 'tasks#change_role'
    get '/tasks/delete', to: 'tasks#destroy'

    post '/works/involvements', to: 'works#add_involvements'
    get '/works/involvements/delete', to: 'works#remove_involvements'

    post '/works/status', to: 'works#change_status'
    post '/works/change_role', to: 'works#change_role'
    get '/works/delete', to: 'works#destroy'

    post '/todos/check_todo', to: 'todos#check_todo'
    get '/todos/delete', to: 'todos#destroy'
    
    get '/comments/delete', to: 'comments#destroy'
    post '/roles/abilities', to: 'roles#abilities'

    get '/roles/abilities/delete', to: 'roles#remove_ability'

    get '/statuses/search', to: 'statuses#search'
    
    get '/reports/search', to: 'reports#search'

    get '/tags/search', to: 'tags#search'
    
    get '/time_sheets/search_ass', to: 'time_sheets#search_associations'
    get '/time_sheets/mine', to: 'time_sheets#mine'
    get '/time_sheets/related', to: 'time_sheets#related'

    post '/settings/add', to: 'settings#add'
    post '/settings/remove', to: 'settings#remove'
    post '/settings/add_block', to: 'settings#add_block'
    post '/settings/remove_block', to: 'settings#remove_block'
    
    get '/uploads/delete', to: 'uploads#destroy'
    
    

    resources :profiles
    resources :roles
    resources :users
    resources :metas
    resources :actuals
    resources :tasks
    resources :statuses
    resources :works
    resources :reports
    resources :uploads
    resources :comments
    resources :tags
    resources :todos
    resources :time_sheets
    resources :devices
    resources :groups
    resources :settings

    post '/users/assignments', to: 'users#assignments'
    get '/users/assignments/delete', to: 'users#delete_assignment'
    post '/users/login', to: 'users#login'
    post '/users/verify', to: 'users#verify'
    post '/users/sign_up', to: 'users#sign_up'
    post '/users/validate_token', to: 'users#validate_token'

  end
end
