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
    resources :users, only: [:show, :edit, :update, :destroy] do
      member do
        delete :hide, as: 'users_hide'
      end
    end

    resources :posts, only: [:index, :show, :edit, :create, :update, :destroy] do
      resources :comments, only: [:create, :destroy]
    end
  end

  namespace :admin do
    root to: 'homes#top'

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
