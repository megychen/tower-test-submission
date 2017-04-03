Rails.application.routes.draw do
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
      end
    end
    resources :members
  end
  root 'teams#index'
end
