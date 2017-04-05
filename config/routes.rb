Rails.application.routes.draw do
  get 'events/index'

  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :teams do
    resources :projects do
      resources :todos do
        member do
          post :start
          post :pause
          post :completed
          post :reopen
          post :deleted
        end
        resources :comments
      end
      resources :accesses
    end
    resources :members
    resources :events
  end
  root 'teams#index'
end
