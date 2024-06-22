class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, :only => [:followings, :followers]


  def followings
    @users = @user.followings
  end

  def followers
    @users = @user.followers
  end

  def create
    @user = User.find(params[:follower])
    current_user.follow(@user)
  end

  def destroy
    @user = current_user.relationships.find(params[:id]).follower
    current_user.unfollow(params[:id])
  end

  def set_user
     @user = User.find(params[:id])
  end
end
