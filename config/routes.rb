Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "works#index"
  resources :works do
    post "/upvote", to: "votes#create", as: "upvote"
  end
  resources :users, only: [:index, :show]

end
