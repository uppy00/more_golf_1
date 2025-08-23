class OauthsController < ApplicationController
  skip_before_action :require_login
  def oauth
    # 指定されたプロバイダの認証ページにユーザーをリダイレクトさせる
    login_at(auth_params[:provider])
  end
  # 先に保存されているアカウントがある場合自動でgoogle認証に登録する
  def callback
    provider = auth_params[:provider]

    if (@user = login_from(provider))
      redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました" and return
    end

    begin
      sorcery_fetch_user_hash(provider)
      email = @user_hash[:email] || @user_hash["email"]
      uid   = @user_hash[:uid]   || @user_hash["uid"]

      if (existing = User.find_by(email: email))
        existing.authentications.find_or_create_by!(provider: provider, uid: uid)
        reset_session
        auto_login(existing)
        redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました" and return
      end

      @user = create_from(provider)
      reset_session
      auto_login(@user)
      redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました"
    rescue => e
      Rails.logger.warn("[OAuth] failed: #{e.class} #{e.message}")
      redirect_to root_path, alert: "#{provider.titleize}アカウントでのログインに失敗しました"
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end

  def signup_and_login(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)
  end
end
