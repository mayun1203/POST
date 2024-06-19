class Admin::HomesController < ApplicationController

  def top
    @users = User.all
    @posts = Post.all
    
  end

  def show
    @post = Post.find(params[:id])
  end
end
