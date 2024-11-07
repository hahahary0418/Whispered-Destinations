Rails.application.routes.draw do
  namespace :admin do
    resources :endusers, only: [:index, :show, :edit, :update]
    get "/admin" => "homes#top"
  end

  scope module: :public do
    root to: "homes#top"
    get "/about" => "homes#about", as: "about"
    get "end_users/mypage" => "end_users#mypage"
    resources :end_users, only: [:show, :edit, :update]
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy]
  end
  
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  devise_scope :user do
    get 'users/sign_out', to: 'devise/sessions#destroy'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
