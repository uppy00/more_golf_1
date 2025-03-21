class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user)
  end
  # postnewを表示させるためのもの
  def new
    @posts = Post.new
  end
end
