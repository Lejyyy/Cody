class ChatsController < ApplicationController
  def create
    project = current_user.projects.find(params[:project_id])
    chat = current_user.chats.find_or_create_by!(project: project)
    redirect_to chat_path(chat)
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @project = @chat.project
    @messages = @chat.messages.order(:created_at)
    @message = Message.new
  end

  def destroy
    chat = current_user.chats.find(params[:id])
    chat.destroy
    redirect_to project_path(chat.project), notice: "Chat supprimé."
  end
end
