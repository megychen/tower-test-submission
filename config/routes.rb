Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :teams do
    resources :projects
  end
  resources :projects
  
  root 'teams#index'
end
