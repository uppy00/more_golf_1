class PostsController < ApplicationController
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:tag, :postable).order(created_at: :desc).page(params[:page]).per(6)
  end
  # postnewを表示させるためのもの
  def new
    @post = Post.new
    @post.tag_id = params[:tag_id] if params[:tag_id].present?
    @post.tag = Tag.find_by(id: @post.tag_id)
    case @post.tag&.name
    when "スコア記録"
      @post.postable = ScoreRecord.new
    when "練習記録"
      @post.postable = PracticeRecord.new
    else
      # 質問やその他の場合はポリモーフィック処理なし
    end
  end
  # 投稿の作成
  def create
    tag = Tag.find_by(id: params[:post][:tag_id])

    if tag&.name == "スコア記録"
      postable = ScoreRecord.new(postable_params)
    elsif tag&.name == "練習記録"
      postable = PracticeRecord.new(postable_params)
    else
      postable = nil
    end

    @post = current_user.posts.build(post_params)
    @post.tag = tag
    @post.postable = postable if postable.present?

    if @post.save
      redirect_to posts_path, notice: "投稿に成功しました"
    else
      flash.now[:danger] = "投稿に失敗しました"
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
    # 編集時はpostableもしくはbuild(新規postable用)
    if @post.postable.nil? && @post.tag.present?
      case @post.tag.name
      when "スコア記録"
        @post.postable = ScoreRecord.new
      when "練習記録"
        @post.postable = PracticeRecord.new
      end
    end
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
    @liked_posts = @q.result.includes(:user, :postable).order(created_at: :desc)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image, :tag_id)
  end

  def postable_params
    params.require(:post).fetch(:postable_attributes, {}).permit(
      :course_name, :score,
      :driving_range_name, :practice_hour, :ball_count, :effort_focus, :video_reference
    )
  end
end
