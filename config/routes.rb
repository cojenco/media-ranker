Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # verb 'path', to: 'controller#action'
  root to: "homepages#index"

  resources :users, only: [:index, :show]
  resources :works do
    post "/upvote", to: "votes#create", as: "upvote"
  end

  get "/login", to: "users#login_form", as: "login"
  post "/login", to: "users#login"
  post "/logout", to: "users#logout", as: "logout"
  
end
