class CommentsController < ApplicationController
  before_action :set_post

  def create
    # ポストに紐づいた新しいコメントを作成
    @comment = @post.comments.build(comment_params)
    # コメントしたユーザーを設定（ログインしているユーザー）
    @comment.user = current_user

    if @comment.save
      flash[:success] = "コメントを投稿しました"
      redirect_to @post
    else
      flash[:danger] = "コメントの投稿に失敗しました"
      redirect_to @post
    end
  end

  private
  # コメントを投稿するポストを取得
  def set_post
    @post = Post.find(params[:post_id])
  end
  # コメント本文のみ受け取る
  def comment_params
    params.require(:comment).permit(:body)
  end
end
