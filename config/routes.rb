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
    get "/payment", to: "cart#checkout"

    resources :users
  end
end
