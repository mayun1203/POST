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
    resources :users, only: [:show, :edit, :update, :destroy]
    resources :posts, only: [:index, :show, :edit, :create, :update, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
