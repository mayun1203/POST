class Public::FavoritesController < ApplicationController
  def create

    #投稿にいいねされた時の通知


    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.new(post_id: @post.id)
    if @favorite.save
      if current_user != @post.user
        @post.create_notification_favorite_post!(current_user)
      end
    end
    render 'replace_btn'
  end

  def destroy
    post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post_id: post.id)
    @favorite.destroy
    render 'replace_btn'
  end
end
