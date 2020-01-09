Rails.application.routes.draw do
  root "pages#home"
  devise_for :users

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
  end


end
