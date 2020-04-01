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



    post '/roles/abilities', to: 'roles#abilities'
    get '/roles/abilities/delete', to: 'roles#remove_ability'

    resources :profiles
    resources :roles
    resources :users
    resources :metas
    resources :actuals
    resources :tasks


    post '/users/assignments', to: 'users#assignments'
    get '/users/assignments/delete', to: 'users#delete_assignment'
    post '/users/login', to: 'users#login'
    post '/users/sign_up', to: 'users#sign_up'

  end
end
