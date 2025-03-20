class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
  end
  # login sorceryのメソッド
  def create
    @user = login(params[:email], params[:password])

    if @user
      flash[:success] = "ログインしました。"
      redirect_to root_path
    else
      flash.now[:danger] = "ログインに失敗しました。メールアドレスまたはパスワードが正しいか確認してください。"
      render :new
    end
  end

  def destroy
    logout
    flash[:notice] = "ログアウトしました。"
    redirect_to root_path, status: :see_other
  end
end
