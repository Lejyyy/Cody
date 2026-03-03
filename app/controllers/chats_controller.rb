class ChatsController < ApplicationController
  def create
    project = current_user.projects.find(params[:project_id])

    current_user.chats.find_or_create_by!(project: project)

    redirect_to project_path(project)
  end

  def destroy
    chat = current_user.chats.find(params[:id])
    project = chat.project
    chat.destroy

    redirect_to project_path(project), notice: "Chat supprimé."
  end
end
