Rails.application.routes.draw do

  # Routes Landing Page
  root 'home#index'

  # Routes App 
  get "app", controller: :app, action: :index
  devise_for :users, controllers: {sessions: 'app/sessions', registrations: 'app/registrations'}
  namespace :app do 
  
  
  end 

  # Routes Admin 
  get "admin", controller: :admin, action: :index

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
