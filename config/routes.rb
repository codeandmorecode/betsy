Rails.application.routes.draw do

  root to: "users#index"

  get "/users/current", to: "users#current", as: "current_user"

  # Omniauth login route
  get "/auth/github", as: "github_login"

  # Omniauth callback route
  get "/auth/:provider/callback", to: "users#create", as: "omniauth_callback"

  resources :users

  delete "/logout", to: "users#destroy", as: "logout"

  resources :products do
    resources :reviews, only: [:create]
  end

  resources :categories, except: [:edit, :update, :destroy]


  post "/orders/status", to: "orders#status_filter", as: "order_status_filter"

  resources :shipping_infos
  resources :billing_infos

  get "/orders/:id/checkout", to: "orders#checkout", as: "checkout_order"
  post "/orders/:id/checkout", to: "orders#submit"
  post "/orders/:id/complete", to: "orders#complete", as: "complete_order"
  post "/orders/:id/cancel", to: "orders#cancel", as: "cancel_order"
  resources :orders, except: [:new, :edit] do
    resources :shipping_infos, only: [:show, :edit, :update, :destroy]
    resources :billing_infos, only: [:show, :edit, :update, :destroy]
  end
end
