Rails.application.routes.draw do

  resources :users do
    member do
      get :following, :followers
    end
  end
  
  resources :hills do
    collection do
      post :import      
      post :get_mates
      post :get_hill_names
      post :create_links
      post :update_links
      post :update_sidebar
      post :update_multiple
      get  :upload
      get  :delete_all
    end
  end
  
  resources :ascents do
    collection do
      post :import
      post :get_edit
      post :update_multiple
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
 
  #root  'static_pages#home'
  root 'hills#index'

  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

  match '/destroy_all_ascents', to: 'ascents#destroy_all', via: 'delete'
  match '/destroy_all_hills', to: 'hills#destroy_all', via: 'delete'

end
