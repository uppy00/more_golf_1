class TopPagesController < ApplicationController
  # topアクションにアクセスする際にだけログインしていなくてもいい
  skip_before_action :require_login, only: %i[top]
  # loginしていたらyeildにtop.htmlをしていなければbefore_login_topを
  def top
    @recent_posts = Post.includes(:user, :tag).order(created_at: :desc).limit(5)
    if logged_in?
      render "top"
    else
      render "before_login_top"
    end
  end
end
