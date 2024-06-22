class Public::FavoritesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    @favorite = current_user.favorites.new(post_id: post.id)
    @favorite.save
    render 'replace_btn'

    #投稿にいいねされた時の
    if current_user != @post.user
      @post.create_notification_favorite_post!(current_user)
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post_id: post.id)
    @favorite.destroy
    render 'replace_btn'
  end
end
