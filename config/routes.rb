Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "works#index"
  resources :works
  resources :users, only: [:index, :show]

end
