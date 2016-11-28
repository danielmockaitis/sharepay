Rails.application.routes.draw do
  root to: 'visitors#index'
  # match '/rent_local/index' => 'boards#new2', via: [:get, :post]
  match '/transactions' => 'transactions#index', via: [:get, :post]
  match '/transactions/new' => 'transactions#new', via: [:get, :post]
  match '/transactions/show/:id', :to => 'transactions#show', :as => :transactions_show, via: [:get]
  match '/transactions/approve/:id', :to => 'transactions#approve', :as => :transactions_approve, via: [:post]
  match '/transactions/requests' => 'transactions#requests', via: [:get, :post]
  match '/transactions/run/:id' => 'transactions#run', :as => :transactions_run, via: [:post]
  match '/signup' => 'users#signup', via: [:get, :post]
  match '/signup/creditcard' => 'users#credit_card', via: [:get, :post]
  match '/login' => 'users#login', via: [:get, :post]
  match '/logout' => 'users#logout', via: [:get, :post]
  match '/users/:id', :to => 'users#show', :as => :user, via: [:get, :post]
  # resources :transactions

end
