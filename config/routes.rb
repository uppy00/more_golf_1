Rails.application.routes.draw do
  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root "top_pages#top"
  resources :password_resets, only: %i[new create edit update]

  # ユーザ登録のルーティング
  resources :users, only: %i[new create show edit update] do
    resource :golf_gear
  end
  # ユーザーログインのルーティング new(get)はログインフォームを表示するため(post)は送られてきたデーターを処理するため
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"

  resources :posts, only: %i[index new create destroy show edit update] do
    resources :comments, only: %i[create edit destroy], shallow: true
    collection do
      # いいねされている一覧
      get :likes
      # オートコンプリート用のルーティング
      get :autocomplete_title
    end
  end
  # いいねの登録と解除
  resources :likes, only: %i[create destroy], param: :post_id
end
