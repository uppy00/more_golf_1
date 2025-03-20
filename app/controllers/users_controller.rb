class UsersController < ApplicationController
  # require_loginをnew及びcreateにのみスキップ
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザーの登録に成功しました"
      redirect_to root_path
    else
      flash.now[:danger] = "ユーザーの作成に失敗しました。エラーを確認してください"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
