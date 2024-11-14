class Admin::PostsController < ApplicationController
  
  before_action :authenticate_admin!

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end
  
  private
  
  def authenticate_admin!
    unless admin_signed_in?
      redirect_to new_admin_session_path
    end
  end

end
