Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  api_version(:module => "V1", :path => {:value => "v1"}) do

    get '/actuals/delete', to: 'actuals#delete'
    get '/profiles/search', to: 'profiles#search'
    put '/profiles', to: 'profiles#update'
    get '/profiles/my', to: 'profiles#my'
    post '/profiles/add_experties/:id', to: 'profiles#add_experties'
    post '/profiles/remove_experties/:id', to: 'profiles#remove_experties'

    post '/tasks/participants', to: 'tasks#add_participants'
    get '/tasks/participants/delete', to: 'tasks#remove_participants'
    post '/tasks/status', to: 'tasks#change_status'
    post '/tasks/change_role', to: 'tasks#change_role'

    
    post '/works/participants', to: 'works#add_participants'
    get '/works/participants/delete', to: 'works#remove_participants'
    post '/works/status', to: 'works#change_status'
    post '/works/change_role', to: 'works#change_role'

    post '/todos/check_todo', to: 'todos#check_todo'
    
    get '/comments/delete', to: 'comments#destroy'
    post '/roles/abilities', to: 'roles#abilities'
    get '/roles/abilities/delete', to: 'roles#remove_ability'

    get '/statuses/search', to: 'statuses#search'
    
    get '/reports/search', to: 'reports#search'
    get '/tags/search', to: 'tags#search'
    

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

    post '/users/assignments', to: 'users#assignments'
    get '/users/assignments/delete', to: 'users#delete_assignment'
    post '/users/login', to: 'users#login'
    post '/users/verify', to: 'users#verify'
    post '/users/sign_up', to: 'users#sign_up'

  end
end
