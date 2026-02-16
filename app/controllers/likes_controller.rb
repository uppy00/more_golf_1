class LikesController < ApplicationController
  before_action :set_post

  def create
    current_user.like(@post)

    # 通知を作成
    @post.create_notification_like!(current_user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path }
    end
  end

  def destroy
    current_user.unlike(@post)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
