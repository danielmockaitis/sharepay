Rails.application.routes.draw do
  root to: 'visitors#index'
  # match '/rent_local/index' => 'boards#new2', via: [:get, :post]
  match '/transactions' => 'transactions#index', via: [:get, :post]
  match '/transactions/new' => 'transactions#new', via: [:get, :post]
  match '/signup' => 'users#signup', via: [:get, :post]
  match '/signup/creditcard' => 'users#credit_card', via: [:get, :post]
  match '/login' => 'users#login', via: [:get, :post]
  match '/logout' => 'users#logout', via: [:get, :post]
  match '/users/:id', :to => 'users#show', :as => :user, via: [:get, :post]
end
