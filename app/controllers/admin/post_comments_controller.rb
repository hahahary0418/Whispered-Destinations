class Admin::PostCommentsController < ApplicationController
  
  def destroy
    @comment = PostComment.find(params[:id])
    @post = Post.find(@comment.post_id)
    @comment.destroy
    redirect_to admin_post_path(@comment.post)
  end
  
  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
  
end
