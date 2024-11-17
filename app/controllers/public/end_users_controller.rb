class Public::EndUsersController < ApplicationController
  before_action :authenticate_user!

  def mypage
    @user = current_user
    @posts = @user.posts
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
       redirect_to end_users_mypage_path
    else
      render :edit
    end
  end
  
  def check
    
  end

  def withdraw
    @user = current_user
    @user.soft_delete
    sign_out @user
    redirect_to root_path, notice: 'アカウントは退会処理されました。'
  end
  
  def favorites
    @user = User.find(params[:id]) # 現在のユーザーを取得
    @favorite_posts = @user.favorites.includes(:post).map(&:post) # ユーザーがいいねした投稿を取得
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :introduction, :profile_image)
  end
  
  def is_matching_login_user
    user = current_user
    unless user.id == current_user.id
      redirect_to end_users_mypage_path
    end
  end

end
