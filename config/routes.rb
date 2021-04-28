Rails.application.routes.draw do

  # * Friends controller routes without using resources

  # get "/friends/", to: "friends#index", as: "friends"
  # post "/friends/", to: "friends#create"
  # delete "/friends/:id", to: "friends#destroy", as: "friend"

  # * Generated Groups controller routes using resources

  # get 'groups/index'
  # get 'groups/new'
  # get 'groups/create'
  # get 'groups/destroy'
  # get 'groups/add_user'
  # get 'groups/create_user'
  # get 'groups/destroy_user'
  get "search_user_to_invite", to: "orders#search"
  get "add_user_to_invited_list", to: "orders#addToInvitedList"
  get "remove_user_from_invited_list", to: "orders#removeFromInvitedList"
  get "user_accepte_to_join_order", to: "orders#joinOrder"
  get "user_refuse_to_join_order", to: "orders#cancelInvitaion"
  # for invited and joined users
  get 'orders/:order_id/invited', :to => 'orders#order_Invited', as: "order_invited"
  get 'orders/:order_id/joined', :to => 'orders#order_Joined', as: "order_joined"
  get 'orders/:order_id/joined', :to => redirect('/order_joined.html.erb')
  get 'orders/:order_id/invited', :to => redirect('/order_invited.html.erb')

  # for removing users from order
  get 'orders/:order_id/joined/:invited_id', :to => 'orders#remove_Joined', as: "remove_joined"
  get 'orders/:order_id/invited/:invited_id', :to => 'orders#remove_Invited', as: "remove_invited"



  resources :friends
  resources :groups do
    get "/user", to: "groups#add_user", as: "add_user"
    post "/user", to: "groups#create_user", as: "create_user"
    delete "/user/:user_id", to: "groups#destroy_user", as: "destroy_user"
    get "search_user", to: "groups#search"
  end

  # * resource for notification
  resources :notifications

  # * resource for order
  resources :orders do
    resources :order_members
  end

  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  authenticated :user do
    root "pages#home", as: "authenticated_root"
  end

  devise_scope :user do
    root "devise/sessions#new"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
