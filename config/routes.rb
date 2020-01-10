Rails.application.routes.draw do
  get 'histories/index'
  get 'favorites/index'
  get 'users/show'
  root "pages#home"
  devise_for :users

  resources :users do
    resources :favorites, only: %i[index]
    resources :histories, only: %i[index]
  end

  resources :jobs, only: %i[index show]

  resources :cities, only: %i[index show] do
    resources :jobs, only: %i[index]
  end

  resources :industries, only: %i[index show] do
    resources :jobs, only: %i[index]
  end

  resources :jobs do
    resources :requests, only: %i[new]
    get "requests/confirm", to: "requests#confirm"
    get "requests/done", to: "requests#done"

    resources :favorites, only: %i[create destroy]
  end


end
