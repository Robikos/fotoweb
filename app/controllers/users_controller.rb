class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def index
    if user_signed_in?
      render json: current_user
    else
      render json: {user: nil}
    end
  end

  def show
    @user = User.find_by_username(params[:id])
    if !@user
      @user = {user: nil, meta: {friendship: nil}}
    else
      @friendship = !Friendship.where(user_id: current_user.id).where(friend_id: @user.id).first.nil? if current_user
    end

    render json: @user, meta: {friendship: @friendship}
  end

  def update
    current_user.update(user_params)
    render json: current_user
  end

  private

  def user_params
    params.require(:user).permit(:avatar)
  end
end
