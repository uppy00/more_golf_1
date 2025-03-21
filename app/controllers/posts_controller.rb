class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user)
  end

  def new
    @posts = Post.new
  end
end
