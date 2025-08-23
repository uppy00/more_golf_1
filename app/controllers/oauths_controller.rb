class OauthsController < ApplicationController
  skip_before_action :require_login
  def oauth
    # 指定されたプロバイダの認証ページにユーザーをリダイレクトさせる
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if (@user = login_from(provider))
      Rails.logger.info("[OAuth] login_from success user_id=#{@user.id} logged_in?=#{logged_in?}")
      redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました"
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        Rails.logger.info("[OAuth] create_from+auto_login success user_id=#{@user.id} logged_in?=#{logged_in?}")
        redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました"
      rescue => e
        Rails.logger.warn("[OAuth] failed: #{e.class} #{e.message}")
        redirect_to root_path, alert: "#{provider.titleize}アカウントでのログインに失敗しました"
      end
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
