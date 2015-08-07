class LikesController < ApplicationController
  def create
    @like = Like.new
    @like.post_id = params[:post_id]
    @like.user_id = current_user.id
    if @like.save
      render json: @like
    else
      msg = "Error occurred. Didn't like"
      render json: @like, meta: { alert: msg }
    end 
  end

  def destroy
    @like = Like.where(user_id: current_user.id).where(post_id: params[:post_id]).first
    if @like && @like.destroy
      render json: @like
    else
      msg = "Error occurred. Like still exists"
      render json: @like, meta: { alert: msg }
    end
  end
end
