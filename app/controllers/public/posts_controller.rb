class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    delete_user_ids = User.where(is_active: false).pluck(:id)
    @genre = params[:genre]
    if @genre == "shine"
      @posts = Post.where(genre: 0).where.not(user_id: delete_user_ids)
    elsif @genre == "dark"
      @posts = Post.where(genre: 1).where.not(user_id: delete_user_ids)
    else
      @posts = Post.where.not(user_id: delete_user_ids)
    end
    @user = current_user
    @post = Post.new
  end


  def show
    @post = Post.find(params[:id])
    # コメント一覧表示で使用する全コメントデータを代入（新着順で表示）
    @comments = @post.comments.order(created_at: :desc)
    # コメントの作成
    @comment = Comment.new
  end

  def shine_new
    @post = Post.new
  end

  def dark_new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    genre = @post.genre
    if @post.save
    else
      flash[:danger] = "投稿に失敗しました。"
      @posts = Post.where(genre: genre)
      @user = current_user
      @posts = @user.posts
      @genre = params[:genre]
      @posts_shine = @posts.where(genre: 0)
      @posts_dark = @posts.where(genre: 1)
      if params[:post][:path] == "mypage"
      render '/public/users/mypage'
      end
      return
    end

    if params[:post][:path] == "mypage"
      redirect_to users_mypage_path
    else
      redirect_back(fallback_location: homes_about_path)
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @genre = @post.genre
    if @post.update(post_params)
      flash[:success] = "投稿に成功しました。"
      redirect_to users_mypage_path(genre: @genre)
    else
      flash[:danger] = "登録に失敗しました。"
      render 'public/posts/edit'
    end
  end

  def destroy
    @posts = Post.all
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to users_mypage_path
  end

  private

  def post_params
    params.require(:post).permit(:name, :account_id, :body, :image, :genre, :post)
  end

  def correct_user
    @post = Post.find(params[:id])
    @user = @post.user
    @genre = @post.genre
    redirect_to posts_path(@genre) unless @user == current_user
  end
end
