Rails.application.routes.draw do

  root "pages#home"
  devise_for :users
  devise_for :admins

  namespace :admins do
    resources :requests, only: %i[index]
  end

  resources :users do
    resources :favorites, only: %i[index]
    resources :histories, only: %i[index]
    resources :requests, only: %i[index]
  end

  resources :jobs, only: %i[index show]

  resources :cities, only: %i[index show] do
    resources :jobs, only: %i[index]
  end

  resources :industries, only: %i[index show] do
    resources :jobs, only: %i[index]
  end

  resources :jobs do
    resources :requests, only: %i[new create index]
    post "requests/confirm", to: "requests#confirm"
    post "requests/done", to: "requests#done"

    resources :favorites, only: %i[create destroy]
  end
end
