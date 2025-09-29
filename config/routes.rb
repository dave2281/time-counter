Rails.application.routes.draw do
  get "/confirm", to: "confirmations#show", as: :confirm

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  root "pages#main"
  # get "calendar", to: "pages#calendar", as: :calendar
  resources :deeds
  resources :users
  post "daily_logs/toggle_timer", to: "daily_logs#toggle_timer"
  post "daily_logs/start_timer", to: "daily_logs#start_timer"
  post "daily_logs/stop_timer", to: "daily_logs#stop_timer"
  get 'daily_logs/timer_status', to: 'daily_logs#timer_status'

  get "/contacts", to: "pages#contacts", as: :contacts
  get "/about-project", to: "pages#about_project", as: :about_project


  resource :session
  resources :passwords, param: :token
end
