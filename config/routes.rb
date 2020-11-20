Rails.application.routes.draw do


  root to: "users#index"

  get "/users/current", to: "users#current", as: "current_user"

  # Omniauth login route
  get "/auth/github", as: "github_login"

  # Omniauth callback route
  get "/auth/:provider/callback", to: "users#create", as:"omniauth_callback"

  resources :users

  delete "/logout", to: "users#destroy", as: "logout"

  resources :products


  post "/orders/:id/cancel", to: "orders#cancel", as: "cancel_order"
  post "/orders/status", to: "orders#status_filter", as: "order_status"
  get "orders/:id/checkout", to: "orders#checkout", as: "checkout_order"
  post "/orders/:id/complete", to: "orders#complete", as: "complete_order"
  resources :orders, except: [:new]
end