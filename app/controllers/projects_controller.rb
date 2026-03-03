class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects.order(created_at: :desc)
  end

  def show
    @project = current_user.projects.find(params[:id])
    @chat = current_user.chats.find_by(project: @project)
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to @project, notice: "Projet créé."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :goal, :stack)
  end
end
