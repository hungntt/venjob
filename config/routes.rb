Rails.application.routes.draw do
  get 'cities/index'
  get 'cities/show'
  root "pages#home"
  devise_for :users
  resources :cities
end
