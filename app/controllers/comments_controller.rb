class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment.post_id = params[:post_id]
    @comment.author = current_user

    if @comment.save
      msg = "Comment added successfully"
    else
      msg = "An error occurred"
    end

    render json: @comment, meta: { alert: msg }
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.author == current_user && @comment.update_attributes(comment_params)
      msg = "Comment added successfully"
    else
      msg = "An error occurred"
    end

    render json: @comment, meta: { alert: msg }
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.author == current_user && @comment.destroy
      msg = "Comment removed successfully"
    else
      msg = "An error occurred"
    end

    render json: @comment, meta: { alert: msg }
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
