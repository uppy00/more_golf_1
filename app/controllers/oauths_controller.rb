class OauthsController < ApplicationController
  skip_before_action :require_login
  def oauth
    # 指定されたプロバイダの認証ページにユーザーをリダイレクトさせる
    login_at(auth_params[:provider])
  end
  # 先に保存されているアカウントがある場合自動でgoogle認証に登録する
  def callback
    provider = auth_params[:provider]

    # 1) 既に authentication があればそのままログイン
    if (@user = login_from(provider))
      Rails.logger.info("[OAuth] login_from success user_id=#{@user.id} logged_in?=#{logged_in?}")
      redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました"
      return
    end

    begin
      # 2) Google から user_hash を取得（形が環境で揺れるので with_indifferent_access を使う）
      sorcery_fetch_user_hash(provider)
      info = (@user_hash[:user_info] || @user_hash["user_info"] || {}).with_indifferent_access
      # 取り得る場所を総当たりで拾う
      email = info[:email] || @user_hash[:email] || @user_hash["email"]
      uid   = @user_hash[:uid] || info[:id] || info[:sub] || info[:uid]

      Rails.logger.info("[OAuth] user_hash keys=#{@user_hash.keys} info_keys=#{info.keys} email=#{email.inspect} uid=#{uid.inspect}")

      unless uid.present?
        Rails.logger.warn("[OAuth] missing uid for provider=#{provider} email=#{email.inspect}")
        redirect_to root_path, alert: "#{provider.titleize}アカウントの取得に失敗しました"
        return
      end

      # 3) 既存ユーザーが同じ email なら紐付けてログイン（今回の肝）
      if email.present? && (existing = User.find_by(email: email))
        existing.authentications.find_or_create_by!(provider: provider, uid: uid)
        reset_session
        auto_login(existing)
        Rails.logger.info("[OAuth] linked provider to existing user_id=#{existing.id} logged_in?=#{logged_in?}")
        redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました"
        return
      end

      # 4) 既存が居なければ新規作成 → ログイン
      @user = create_from(provider)
      reset_session
      auto_login(@user)
      Rails.logger.info("[OAuth] create_from success user_id=#{@user.id} logged_in?=#{logged_in?}")
      redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました"

    # ← ここが保険：万一 create_from が重複で落ちたら、email で既存を紐付けてログイン
    rescue ActiveRecord::RecordNotUnique => e
      Rails.logger.warn("[OAuth] RecordNotUnique: #{e.message}")
      info = (@user_hash[:user_info] || @user_hash["user_info"] || {}).with_indifferent_access
      email = info[:email] || @user_hash[:email] || @user_hash["email"]
      uid   = @user_hash[:uid] || info[:id] || info[:sub] || info[:uid]

      if email.present? && (existing = User.find_by(email: email))
        existing.authentications.find_or_create_by!(provider: provider, uid: uid)
        reset_session
        auto_login(existing)
        redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました"
      else
        redirect_to root_path, alert: "同一メールのアカウントが既に存在します。メールでログイン後に連携してください。"
      end

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
