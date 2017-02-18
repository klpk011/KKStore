Rails.application.routes.draw do
    root 'welcome#index'

    devise_for :users
    namespace :admin do
        resources :products
        resources :categories
    end
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    resources :products do
        member do
            post :add_to_cart
        end
    end
    resources :carts do
        collection do
            delete :clean
            post :checkout
        end
    end

    resources :orders

    resources :cart_items

    namespace :account do
        resources :orders
    end
end
