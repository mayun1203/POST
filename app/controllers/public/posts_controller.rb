class Public::PostsController < ApplicationController

  def index
    @genre = params[:genre]
    if @genre == "shine"
      @posts = Post.where(genre: 0)
    elsif @genre == "dark"
      @posts = Post.where(genre: 1)
    else
      @posts = Post.all
    end
    @user = current_user
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
    @post.save
    if params[:post][:path] == "mypage"
      redirect_to users_mypage_path
    else
      redirect_to posts_path(genre: post_params[:genre])
    end
  end

  def update
  end

  def destroy
    @posts = Post.all
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path(genre: post_params[:genre])
  end

  private

  def post_params
    params.require(:post).permit(:name, :body, :image, :genre)
  end
end
