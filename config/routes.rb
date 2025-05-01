Rails.application.routes.draw do
  root "top_pages#top"

  # ユーザ登録のルーティング
  resources :users, only: %i[new create show edit update]
  # ユーザーログインのルーティング new(get)はログインフォームを表示するため(post)は送られてきたデーターを処理するため
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"

  resources :posts, only: %i[index new create destroy show edit update] do
    resources :comments, only: %i[create edit destroy], shallow: true
    collection do
      # いいねされている一覧
      get :likes
    end
  end
  # いいねの登録と解除
  resources :likes, only: %i[create destroy]
end
