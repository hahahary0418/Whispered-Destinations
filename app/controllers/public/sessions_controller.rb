# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # Deviseのデフォルトのcreateメソッドをオーバーライドする
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    
    # 退会済みのユーザーを確認
    if resource.is_deleted?
      flash[:alert] = "このアカウントは退会済みです。"
      sign_out(resource) # ログアウトさせる
      redirect_to new_user_session_path # ログインページにリダイレクト
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end
  
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  protected

  # 退会済みのユーザーかどうかを確認
  def is_deleted?
    @user = User.find_by(email: params[:user][:email])
    return unless @user

    if @user.valid_password?(params[:user][:password]) && @user.is_deleted?
      redirect_to new_user_registration_path and return true
    end
    false
  end
end