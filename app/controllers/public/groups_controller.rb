class Public::GroupsController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy, :permits]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.find(params[:group_id])
    @permit = Permit.find(params[:permit_id])
  
    # 作成者を自動的にそのグループに追加
    GroupUser.create(user_id: @permit.user_id, group_id: @group.id)
  
    # もしグループ作成者（オーナー）をグループに参加させる場合
    GroupUser.create(user_id: @group.owner_id, group_id: @group.id)
  
    @permit.destroy # 参加希望者リストから削除する
  
    redirect_to group_path(@group), notice: "参加が承認され、あなたはグループに参加しました"
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end
  
  def destroy
    @group = Group.find(params[:id])
    if @group.owner_id == current_user.id  # 作成者のみ削除可能
      @group.destroy
      redirect_to groups_path, notice: "グループが削除されました"
    else
      redirect_to groups_path, alert: "グループの削除権限がありません"
    end
  end

  def permits
    @group = Group.find(params[:id])
    @permits = @group.permits
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  # params[:id]を持つ@groupのowner_idカラムのデータと自分のユーザーIDが一緒かどうかを確かめる。
  # 違う場合、処理をする。グループ一覧ページへ遷移させる。before_actionで使用する。
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to group_path(@group), alert: "グループオーナーのみ編集が可能です"
    end
  end

end
