class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    Rails.logger.debug "[Sorcery] wait sec = #{User.sorcery_config.reset_password_time_between_emails}"
    Rails.logger.debug "[Sorcery] last sent = #{@user&.reset_password_email_sent_at}"
    @user&.deliver_reset_password_instructions!
    redirect_to login_path
    flash[:success]= "パスワードリセットのメールを送信しました"
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end

    @user.skip_nickname_validation = true

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      redirect_to login_path
      flash[:success]= "パスワードがリセットされました"
    else
      render action: "edit"
    end
  end
end
