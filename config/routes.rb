Rails.application.routes.draw do
  get 'events/index'

  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :teams do
    resources :projects do
      member do
        get :members
      end
      resources :todos do
        member do
          post :start
          post :pause
          post :completed
          post :reopen
          post :deleted
        end
        resources :comments
        resources :assignments
      end
      resources :accesses
    end
    #resources :members
    resources :events
    resources :team_permissions
    member do
      get :members
    end
  end
  root 'teams#index'
end
