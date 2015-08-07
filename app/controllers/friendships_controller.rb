class FriendshipsController < ApplicationController
  def index
    @friendships = current_user.friendships.includes(:friend)
    @friends = @friendships.map {|friendship| friendship.friend}

    render json: @friends
  end

  def create
    @friendship = Friendship.new
    @friendship.user_id = current_user.id
    @friendship.friend_id = params[:user_id]

    if !@friendship.save
      msg = "Error while creating friendship"
      render json: @friendship, meta: { alert: msg }
    end

    @friendship = Friendship.new
    @friendship.user_id = params[:user_id]
    @friendship.friend_id = current_user.id

    if !@friendship.save
      msg = "Error while creating friendship"
    else
      msg = "Friendship added successfully!"
    end

    render json: @friendship, meta: { alert: msg }  
  end

  def destroy
    @friendship = Friendship.where(user_id: current_user.id).where(friend_id: params[:user_id]).first
    if @friendship.nil?
      msg = "Friendship doesn't exist. An error occurred"
      render json: @friendship, meta: { alert: msg }
    elsif !@friendship.destroy
      msg = "Error while destroying friendship"
      render json: @friendship, meta: { alert: msg }
    end

    @friendship = Friendship.where(user_id: params[:user_id]).where(friend_id: current_user.id).first
    if @friendship.nil?
      msg = "Friendship doesn't exist. An error occurred"
    elsif !@friendship.destroy
      msg = "Error while destroying friendship"
    else
      msg = "Destroying friendship success!"
    end

    render json: @friendship, meta: { alert: msg }
  end
end
