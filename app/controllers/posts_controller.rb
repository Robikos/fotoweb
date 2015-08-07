class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @user = User.find_by_username(params[:user_id])

    @posts = @user ? @user.posts.order(created_at: :desc) : {posts: nil}

    render json: @posts
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      render json: @post
    else
      msg = "An error occurred. Post wasn't created" + @post.errors.full_messages.join(",")
      render json: @post, meta: { alert: msg }
    end
  end

  def show
    @user = User.find_by_username(params[:user_id])
    @post = Post.find(params[:id])

    @likes = @post.likes.order(created_at: :desc)
    my_like = @likes.where(user_id: current_user.id).first
    @my_like_id = my_like.nil? ? 0 : my_like.id
    @likers = generate_likers

    render json: @post, meta: {my_like_id: @my_like_id, likers: @likers}, serializer: PostWithCommentsSerializer
  end

  def update
    @post = Post.find(params[:id])
    if @post.user == current_user && @post.update_attributes(post_params)
      msg = "Updated successfully"
    else
      msg = "Something went wrong"
    end

    render json: @post, meta: { alert: msg }
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user == current_user
      if @post.destroy
        msg = "Delete successful"
      else
        msg = "An error occurred"
      end
    else
      msg = "You are not owner of that post!"
    end

    render @post, alert: msg
  end

  private

  def post_params
    params.require(:post).permit(:title, :text, :picture)
  end

  def generate_likers
    usernames = User.where(id: @likes.pluck(:user_id)).pluck(:username)
    likes_count = usernames.size
    if likes_count == 0
      ending = "Nobody likes it yet."
    elsif likes_count == 1
      ending = " likes it."
    else
      ending = " like it."
    end

    usernames.join(", ") + ending
  end
end
