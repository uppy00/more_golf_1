# 開発環境と本番環境でcookie設定を変える
if Rails.env.production?
  Rails.application.config.session_store :cookie_store,
    key: "_moregolf_session",
    secure: true,       # 本番は HTTPS 前提
    same_site: :lax,
    httponly: true
else
  Rails.application.config.session_store :cookie_store,
    key: "_moregolf_session",
    secure: false,      # ← 開発は必ず false（http だから）
    same_site: :lax,
    httponly: true
  # 開発では domain を絶対に付けない（localhostにマッチせず破棄されます）
end
