Rails.application.routes.draw do


  root 'attendances#index'

  post '/launch' => 'attendances#index'



end
