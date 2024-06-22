class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!


  def create
    @user = User.find(params[:follower])
    current_user.follow(@user)
  end

  def destroy
    @user = current_user.relationships.find(params[:id]).follower
    current_user.unfollow(params[:id])
  end

end
