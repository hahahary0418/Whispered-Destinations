class Public::EndUsersController < ApplicationController

  def mypage
    @user = current_user
  end

  def show

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

end
