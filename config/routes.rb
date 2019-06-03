Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/select", to: "static_pages#select"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    post "/shoping", to: "cart#shoping"
    get "/cart", to: "cart#show"
    delete "/cart", to: "cart#destroy"
    patch "/cart", to: "cart#update"
    get "/payment", to: "cart#checkout"
    get "/sort_users", to: "users#sort"

    resources :users
    resources :products
    resources :categories
    resources :orders, only: %i(new index create)
    resources :reviews, only: %i(create update)

    namespace :admin do
      resources :orders
    end

    resources :products do
      collection { post :import }
    end
  end
end
