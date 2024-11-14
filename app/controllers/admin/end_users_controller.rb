class Admin::EndUsersController < ApplicationController
  
  before_action :authenticate_admin!
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def withdrawal
    @user = User.find_by(id: params[:id])  # ユーザーの取得を確認
    if @user.present?
      if @user.update(is_deleted: true)  # 更新処理
        flash[:notice] = "退会処理を実行いたしました"
        redirect_to admin_end_users_path  # 正常終了時はリストページにリダイレクト
      else
        flash[:alert] = "退会処理に失敗しました"
        redirect_to admin_end_users_path
      end
    else
      flash[:alert] = "ユーザーが見つかりません"
      redirect_to admin_end_users_path
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :profile_image)
  end
  
  
  
end
