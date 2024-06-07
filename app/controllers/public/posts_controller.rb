class Public::PostsController < ApplicationController

  def new
    @post = Post.new
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
    params.require(:post).permit(:name, :body, :image)
  end
end
