class ProjectsController < ApplicationController
  def index
    @projects = Project.all.order(created_at: :desc)
  end

  def show
    @project = current_user.projects.find(params[:id])
    @chat = current_user.chats.find_by(project: @project)
    @messages = @chat&.messages&.order(:created_at)
    @message = Message.new
  end
end
