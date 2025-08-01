class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # ユーザーがログインしているかどうかを判断　してない場合not_authenticatedに指定したルートにリダイレクト
  before_action :require_login, unless: :high_voltage_static_page?


  private
  # ログインしていない婆はlogin_pathにリダイレクト
  def not_authenticated
    flash[:notice] = "ログインが必要です"
    redirect_to login_path
  end
  # high_voltageで作ったものをログインなしに見れるようにする。
  def high_voltage_static_page?
    controller_name == "pages" && %w[golf_start privacy_policy terms].include?(params[:id])
  end
end
