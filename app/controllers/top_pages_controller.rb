class TopPagesController < ApplicationController
  # topアクションにアクセスする際にだけログインしていなくてもいい
  skip_before_action :require_login, only: %i[top]

  def top
  end
end
