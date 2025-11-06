Rails.application.routes.draw do
  get "/confirm", to: "confirmations#show", as: :confirm

  get "signup", to: "users#new"
  post "signup", to: "users#create"
  get "pages/main", to: "pages#main"
  # get "pages/pomodoro", to: "pages#pomodoro", as: :pomodoro
  root "pages#about_project"

  resources :deeds
  resources :users
  post "daily_logs/toggle_timer", to: "daily_logs#toggle_timer"
  post "daily_logs/start_timer", to: "daily_logs#start_timer"
  post "daily_logs/stop_timer", to: "daily_logs#stop_timer"
  get "daily_logs/timer_status", to: "daily_logs#timer_status"

  get "/contacts", to: "pages#contacts", as: :contacts

  # Profile updates via PATCH
  patch "/update_profile", to: "pages#update_profile", as: :update_profile

  resource :session
  resources :passwords, param: :token
end
