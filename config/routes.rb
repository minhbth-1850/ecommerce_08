Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/select", to: "static_pages#select"
    get "/search", to: "static_pages#search"
    post "/shoping", to: "cart#shoping"
    get "/cart", to: "cart#show"
    delete "/cart", to: "cart#destroy"
    patch "/cart", to: "cart#update"
    get "/payment", to: "cart#checkout"
    get "/sort_users", to: "users#sort"
    get "/statistic", to: "statistics#show"

    resources :users, only: %i(index update destroy) do
      collection do
        get :change_password
        patch :update_password
        get "/profile/:id", to: "users#show", as: "profile"
        get "/change/:id", to: "users#edit", as: "change"
      end
    end

    resources :products
    resources :categories
    resources :orders, only: %i(new index create)
    resources :reviews, only: %i(create update)
    resources :suggestions

    namespace :admin do
      resources :orders
    end

    resources :products do
      collection { post :import }
    end

    devise_for :users, controllers: {
      registrations: "users/registrations"
    }
    devise_scope :user do
      delete "/sign_out", to: "devise/sessions#destroy", as: :sign_out
    end
  end
end
