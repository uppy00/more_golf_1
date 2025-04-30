class UsersController < ApplicationController
  # require_loginをnew及びcreateにのみスキップ
  skip_before_action :require_login, only: %i[new create]
  before_action :set_user, only: %i[show edit update]
  before_action :require_correct_user, only: %i[edit update]


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

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "プロフィールの更新に成功しました"
      redirect_to user_path(@user)
    else
      flash.now[:danger] = "プロフィールの更新に失敗しました。エラーを確認してください"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :nickname, :self_introduction, :favorite_course, :best_score, :best_score_course, :favorite_driving_range, :driving_range_type, :driving_range_price, :favorite_video_creator, :avatar, :prefecture_id)
  end
  # 表示するユーザーの情報を取得
  def set_user
    @user = User.find(params[:id])
  end
  # 自分以外だった場合アクセスを拒否
  def require_correct_user
    unless current_user == @user
      flash[:danger] ="他のユーザーのプロフィールを編集することはできません"
      redirect_to user_path(current_user)
    end
  end
end
