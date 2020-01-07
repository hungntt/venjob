Rails.application.routes.draw do
  root "pages#home"
  devise_for :users

  resources :cities, only: %i[index show] do
    resources :jobs, only: %i[index]
  end

  resources :industries, only: %i[index show] do
    resources :jobs, only: %i[index]
  end

  resources :jobs, only: %i[index show]
end
