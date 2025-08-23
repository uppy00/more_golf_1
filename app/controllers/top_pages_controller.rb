class TopPagesController < ApplicationController
  # topアクションにアクセスする際にだけログインしていなくてもいい
  skip_before_action :require_login, only: %i[top]
  # loginしていたらyeildにtop.htmlをしていなければbefore_login_topを
  def top
    # ここでログ出力
    Rails.logger.info("[TOP] current_user_id=#{current_user&.id} logged_in?=#{logged_in?}")
    if logged_in?
      render "top"
    else
      render "before_login_top"
    end
  end
end
