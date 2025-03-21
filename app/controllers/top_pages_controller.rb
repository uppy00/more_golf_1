class TopPagesController < ApplicationController
  # topアクションにアクセスする際にだけログインしていなくてもいい
  skip_before_action :require_login, only: %i[top]
  # loginしていたらyeildにtop.htmlをしていなければbefore_login_topを
  def top
    if logged_in?
      @posts = Post.all
    else
      render 'before_login_top'
    end
  end
end
