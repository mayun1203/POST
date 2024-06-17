class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(params[:pattern], @word)
    else
      @posts = Post.looks(params[:pattern], @word)
    end
  end
end
