Rails.application.config.session_store :cookie_store,
  key: "_moregolf_session",
  secure: true,     # HTTPS 前提
  same_site: :lax,  # OAuth のトップレベル遷移なら Lax でOK
  httponly: true
#  domain: :all,    # www も運用するなら有効化（apex統一なら不要）
#  tld_length: 2
