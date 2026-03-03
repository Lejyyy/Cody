class ChatsController < ApplicationController
  before_action :set_chat, only: %i[destroy]

  def create
    project = current_user.projects.find(params[:project_id])
    chat = current_user.chats.find_or_create_by!(project: project)

    redirect_to project_path(chat.project)
  end

  def destroy
    project = @chat.project
    @chat.destroy

    redirect_to project_path(project)
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  end
end
