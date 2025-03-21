class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user)
  end
  # postnewを表示させるためのもの
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    logger.debug(params.inspect)
    if @post.save
      flash[:succesgis] = "投稿に成功しました"
      redirect_to posts_path
    else
      flash.now[:danger] = "投稿に失敗しました。エラーメッセージを確認してください"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    redirect_to posts_path
    flash[:success] = "投稿を削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
