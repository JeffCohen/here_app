Rails.application.routes.draw do


  get 'tools/index'
  root 'tools#index'
  
  resources :tools


end
