class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects.order(created_at: :desc)
  end

  def show
    @project = current_user.projects.find(params[:id])
    @chat = current_user.chats.find_by(project: @project)
    @messages = @chat&.messages&.order(:created_at)
    @message = Message.new
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to project_path(@project), notice: "Projet créé."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :short_description, :content, :category, :duration, :level_project, :stack)
  end
end
