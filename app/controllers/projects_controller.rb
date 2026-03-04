class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects.order(created_at: :desc)
  end

  def show
    @project  = current_user.projects.find(params[:id])
    @chat     = current_user.chats.find_by(project: @project)
    @messages = @chat&.messages&.order(:created_at) || []
    @message  = Message.new
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      # ✅ Après création → page de génération (étape 2)
      redirect_to generate_project_path(@project), notice: "Projet créé."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /projects/:id/generate
  def generate
    @project = current_user.projects.find(params[:id])
    @chat    = current_user.chats.find_by(project: @project)
  end

  # POST /projects/:id/kickoff
  def kickoff
    @project = current_user.projects.find(params[:id])
    chat = current_user.chats.find_or_create_by!(project: @project)

    if chat.messages.none?
      ai_text = kickoff_ai_for(@project)
      chat.messages.create!(user: current_user, role: "assistant", content: ai_text)
    end

    redirect_to project_path(@project)
  end

  private

  def project_params
    params.require(:project).permit(
      :name, :short_description, :content, :category, :duration, :level_project, :stack
    )
  end

  def kickoff_ai_for(project)
    prompt = <<~PROMPT
      Tu es un assistant IA spécialisé dans la création d'équipes pour projets tech (Dream Team).
      Ta mission : aider un développeur à structurer rapidement un projet et identifier les bons profils.

      Contexte du projet (formulaire) :
      - Titre : #{project.name}
      - Catégorie : #{project.category}
      - Durée : #{project.duration}
      - Niveau : #{project.level_project}
      - Stack : #{project.stack}
      - Short description : #{project.short_description}
      - Long description : #{project.content}

      Réponds en Markdown, de façon très structurée :

      ## 1) Résumé du projet (en 3 lignes max)
      ## 2) MVP recommandé (3 à 6 features)
      ## 3) Architecture / Stack conseillée
      ## 4) Dream Team (profils + responsabilités + pourquoi)
      ## 5) Roadmap (phases courtes)
      ## 6) Risques & quick wins
    PROMPT

    RubyLLM.chat.ask(prompt).content
  rescue StandardError => e
    "Désolé, l'assistant IA est indisponible pour le moment. (#{e.class})"
  end
end
