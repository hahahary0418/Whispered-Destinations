class Public::GroupUsersController < ApplicationController
  
  def create
    @group = Group.find(params[:group_id])
    @permit = Permit.find(params[:permit_id])

    # 参加希望者をグループに追加
    @group_user = GroupUser.create(user_id: @permit.user_id, group_id: params[:group_id])
    @permit.destroy # 参加希望者リストから削除する

    # 作成者を自動的にそのグループに追加
    @group.users << @group.owner  # グループのオーナー（作成者）を自動的に参加させる

    redirect_to group_path(@group), notice: "参加が承認され、あなたはグループに参加しました"
  end

  def destroy
    # 自分のIDを持ったgroup_userの中から、group_idカラムのデータがグループ詳細ページと一致するものを探す
    group_user = current_user.group_users.find_by(group_id: params[:group_id])
    group_user.destroy
    redirect_to request.referer
  end
  
end
