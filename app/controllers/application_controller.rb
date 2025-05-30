class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # ユーザーがログインしているかどうかを判断　してない場合not_authenticatedに指定したルートにリダイレクト
  before_action :require_login

  private
  # ログインしていない婆はlogin_pathにリダイレクト
  def not_authenticated
    redirect_to login_path
  end
end
