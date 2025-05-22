class PostsController < ApplicationController
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:tag).page(params[:page]).per(6)
  end
  # postnewを表示させるためのもの
  def new
    @post = Post.new
  end
  # 投稿の作成
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "投稿に成功しました"
      redirect_to posts_path
    else
      flash.now[:danger] = "投稿に失敗しました。エラーメッセージを確認してください"
      render :new, status: :unprocessable_entity
    end
  end
  # 投稿の詳細
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end
  # 投稿の編集を登録するもの
  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      flash[:success] = "投稿の編集に成功しました"
      redirect_to post_path(@post)
    else
      flash.now[:danger] = "投稿の編集に失敗しました。エラーメッセージを確認してください"
      render :edit, status: :unprocessable_entity
    end
  end
  # 投稿の編集ページを表示
  def edit
    @post = current_user.posts.find(params[:id])
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    flash[:danger] = "投稿を削除しました"
    redirect_to posts_path
  end

  # いいねした投稿を表示　ransackも使えるように
  def likes
    # current_userのliked_postsをベースにransack検索オブジェクトを作成
    @q = current_user.liked_posts.ransack(params[:q])
    # 検索結果を取得し、userもincludesしてorderもかける
    @liked_posts = @q.result.includes(:user).order(created_at: :desc)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image, :tag_id)
  end
end
