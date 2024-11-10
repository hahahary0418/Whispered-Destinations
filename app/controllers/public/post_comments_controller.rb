class Public::PostCommentsController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    @comment = PostComment.new(post_comment_params)
    @comment.user_id = current_user.id
    @comment.post_id = @post.id
  
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post, notice: 'コメントが投稿されました' }
        format.json { render json: @comment, status: :created }
      else
        format.html { redirect_to @post, alert: 'コメントの投稿に失敗しました' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @comment = PostComment.find(params[:id])
    @post = Post.find(@comment.post_id)
    @comment.destroy
  
    respond_to do |format|
      format.html { redirect_to @post, notice: 'コメントが削除されました' }
      format.json { head :no_content }
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
  
end
