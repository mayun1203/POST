Rails.application.routes.draw do
  #管理者用(URL/admin/sign_in)
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  #会員用(URL/users/sign_in)
  devise_for :users, skip:[:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  root to: "public/homes#top"


  scope module: 'public' do
    get 'about', to: 'homes#about', as: :homes_about
    get 'mypage', to: 'users#mypage', as: :users_mypage
    get 'posts/shine_new', to: 'posts#shine_new', as: :posts_shine_new
    get 'posts/dark_new', to: 'posts#dark_new', as: :posts_dark_new
    get "/search", to: "searches#search"

    resources :users, only: [:show, :edit, :update, :destroy] do
      member do
        delete :hide, as: 'users_hide'
      end
      member do
        get :liked_posts
      end
      member do
        get :followings, :followers
      end
    end

    resources :posts, only: [:index, :show, :edit, :create, :update, :destroy] do
      resources :comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end

    resources :notifications, only: [:index] do
      post :update_checked, on: :collection
    end

    resources :relationships, only: [:create, :destroy]

    resources :rooms, only: [:index, :new, :create] do
      resources :chats, only: [:show, :create, :destroy]
    end
  end

  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :posts, only: [:show, :destroy]
    resources :post_comments, only: [:index, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
