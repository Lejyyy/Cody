class MessagesController < ApplicationController
  def create
    project = current_user.projects.find(params[:project_id])
    chat = current_user.chats.find_by!(project: project)

    message = chat.messages.build(message_params.merge(user: current_user, role: "user"))
    if message.save
      redirect_to project_path(project)
    else
      redirect_to project_path(project), alert: "Message invalide."
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
