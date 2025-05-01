class LikesController < ApplicationController
  before_action :set_post

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    flash[:notice] = "いいねしました"
    redirect_to posts_path
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.unlike(@post)
    flash[:notice] = "いいねを削除しました"
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
