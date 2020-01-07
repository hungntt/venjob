Rails.application.routes.draw do
  get 'jobs/index'
  get 'jobs/show'
  root "pages#home"
  devise_for :users
  resources :cities, only: %i[index show]
  resources :industries, only: %i[index show]
  resources :jobs, only: %i[index show]
end
