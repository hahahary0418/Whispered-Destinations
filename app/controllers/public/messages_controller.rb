class Public::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:group_id].present?
      # グループチャットの場合
      @group = Group.find(params[:group_id])
      @message = @group.messages.build(message_params)
      @message.user = current_user

      if @message.save
        redirect_to chat_group_path(@group), notice: "メッセージを送信しました"
      else
        @messages = @group.messages.includes(:user)
        flash.now[:alert] = "メッセージを送信できませんでした"
        render "public/groups/chat"
      end
    elsif params[:room_id].present?
      # DMの場合
      @room = Room.find(params[:room_id])
      @message = @room.messages.build(message_params)
      @message.user = current_user

      if @message.save
        redirect_to room_path(@room), notice: "メッセージを送信しました"
      else
        @messages = @room.messages.includes(:user)
        flash.now[:alert] = "メッセージを送信できませんでした"
        render "public/rooms/show"
      end
    else
      # エラー処理: グループIDもルームIDも指定されていない場合
      redirect_to root_path, alert: "不正な操作が行われました"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end