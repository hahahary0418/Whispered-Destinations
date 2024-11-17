class Public::MessagesController < ApplicationController
  before_action :authenticate_user!
  
  def create
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
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
