Rails.application.routes.draw do
  root "pages#home"
  devise_for :users
  resources :cities, only: %i[index show]
  resources :industries, only: %i[index show]
end
