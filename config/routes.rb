Rails.application.routes.draw do
  get "industries", to: "industries#index"
  get "cities", to: "cities#index"

  root "pages#home"
  devise_for :users
  resources :cities
end
