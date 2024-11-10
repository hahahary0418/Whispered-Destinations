class Public::EndUsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

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

  def destroy

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
