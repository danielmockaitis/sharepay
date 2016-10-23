Rails.application.routes.draw do
  root to: 'visitors#index'
  # match '/rent_local/index' => 'boards#new2', via: [:get, :post]
  match '/transactions' => 'transaction#index', via: [:get, :post]
  match '/transaction/new' => 'transaction#new', via: [:get, :post]
  match '/login' => 'users#login', via: [:get]
end
