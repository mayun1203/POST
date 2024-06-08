class Public::PostsController < ApplicationController

  def shine_new
    @post = Post.new
  end

  def dark_new
    @post = Post.new
  end

  def index
    if params[:genre] == "shine"
      @posts = Post.where(genre: 0)
    elsif params[:genre] == "dark"
      @posts = Post.where(genre: 1)
    else
      @posts = Post.all
    end
    @user = current_user
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to posts_path
  end
  #def create
    #@post = Post.new(post_params)
    #@post.user_id = current_user.id
    #if @post.save
      #@posts = Post.all
    #else
      #render :index
      #@posts = []
    #end
  #end

  #def destroy
    #@posts = Post.all
    #@post = Post.find(params[:id])
    #@post.destroy
  #end

  private

  def post_params
    params.require(:post).permit(:name, :body, :image, :genre)
  end
end
