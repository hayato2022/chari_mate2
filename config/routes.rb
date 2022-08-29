Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # ユーザー側
   devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

# ログアウトの際method の delete が get になってしまうので以下を追記
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    # ゲストログイン
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    get 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end


  scope module: :public do
    root to: "homes#top"
    get "/about" => "homes#about"
    resources :posts
    get "users/unsubscribe" => "users#unsubscribe"
    patch "users/withdrawal" => "users#withdrawal"
    resources :users, only: [:show, :edit, :update]



    #タグによって絞り込んだ投稿を表示するアクションへのルーティング
    resources :tags do
      get 'posts', to: 'posts#search'
    end
  end





  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
