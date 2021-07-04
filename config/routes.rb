Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  },
                     path: 'auth',
                     path_names: {
                       sign_in: 'login',
                       sign_out: 'logout',
                       password: 'secret',
                       confirmation: 'verification',
                       unlock: 'unblock',
                       registration: 'register',
                       sign_up: 'sign_up'
                     }
  get 'landing/index'
  resources :profile
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'landing#index'
end
