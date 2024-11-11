Rails.application.routes.draw do
  namespace :admin do
    get 'posts/index'
    get 'posts/show'
    get 'posts/edit'
  end
  namespace :admin do
    patch "/end_users/withdrawal/:id" => "end_users#withdrawal", as: "withdrawal"
    resources :end_users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :destroy]do
      resources :post_comments, only: [:destroy]
    end
    get "/admin" => "homes#top"
  end

  scope module: :public do
    root to: "homes#top"
    get "/about" => "homes#about", as: "about"
    get "end_users/mypage" => "end_users#mypage"
    get  '/end_users/check' => 'end_users#check'
    patch  '/end_users/withdraw' => 'end_users#withdraw'
    resources :end_users, only: [:show, :edit, :update]
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy]do
      resource :favorite, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end
    get "/search", to: "searches#search"
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
