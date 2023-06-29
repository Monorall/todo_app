Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }

  resources :tasks do
    member do
      patch :toggle_status
    end
  end

  root 'tasks#index'
end
