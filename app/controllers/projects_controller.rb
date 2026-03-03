class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects
  end

  def show
    @project = current_user.projects.find(params[:id])
    @chat = current_user.chats.find_by(project: @project)
    @messages = @chat&.messages&.order(:created_at)
    @message = Message.new
  end
end
