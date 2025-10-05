class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # コメントアウトすることで古いiOSでも表示できるように、しかし軽く問題が出る可能性もある。
  # allow_browser versions: :modern
  # ユーザーがログインしているかどうかを判断　してない場合not_authenticatedに指定したルートにリダイレクト
  before_action :require_login, unless: :high_voltage_static_page?
  # 携帯でgoogleログインを実装するためのもの
  before_action :redirect_to_canonical_host
  # 本番環境でのみ実装
  before_action :redirect_to_canonical_host, if: -> { Rails.env.production? }

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
  # ホストを正規化（www⇨apexへ強制）
  def redirect_to_canonical_host
    expected = "moregolf-life.com"
    return if request.path == "/up" # Render health checkを除外する場合

    if request.host != expected
      redirect_to "#{request.protocol}#{expected}#{request.fullpath}",
                  allow_other_host: true,
                  status: :moved_permanently
    end
  end
end
