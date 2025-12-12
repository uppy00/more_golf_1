class GolfGearsController < ApplicationController
  before_action :set_user
  before_action :set_golf_gear, only: %i[show edit update destroy]
  # 他ユーザーのゴルフギアを変更できないように
  before_action :require_correct_user, only: %i[new edit update destroy]

  def new
    @golf_gear = @user.build_golf_gear
  end

  def create
    @golf_gear = @user.build_golf_gear(golf_gear_params)
    if @golf_gear.save
      redirect_to user_golf_gear_path(@user), notice: "ゴルフギアを登録しました"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @golf_gear.update(golf_gear_params)
      redirect_to user_golf_gear_path(@user), notice: "ゴルフギアを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @golf_gear.destroy
    redirect_to new_user_golf_gear_path(@user), notice: "ゴルフギアを削除しました"
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_golf_gear
    @golf_gear = @user.golf_gear
  end

  def require_correct_user
    unless current_user == @user
      flash[:danger] = "他のユーザーのギアを編集することはできません"
      redirect_to user_path(current_user)
    end
  end

  def golf_gear_params
    params.require(:golf_gear).permit(
      :club_image,
      :driver_brand, :driver_image,
      :iron_brand, :iron_image,
      :wedge_brand, :wedge_image,
      :putter_brand, :putter_image,
      :ball_brand, :ball_image,
      :caddy_bag_brand, :caddy_bag_image
    )
  end
end
