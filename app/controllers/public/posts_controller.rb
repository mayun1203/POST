class Public::PostsController < ApplicationController

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
    end

    if params[:post][:path] == "mypage"
      redirect_to users_mypage_path
    else
      render :index
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update

    @post = Post.find(params[:id])
    @genre = @post.genre
    if @post.update(post_params)
      flash[:notice] = "You have updated post successfully."
      redirect_to users_mypage_path(genre: @genre)
    else
      flash[:danger] = "登録に失敗しました。"
      render :edit
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
end
