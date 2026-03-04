# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :generate, :kickoff]

  def index
    @projects = current_user.projects.order(created_at: :desc)
  end

  def show
    @chat = current_user.chats.find_by(project: @project)
    @messages = @chat&.messages&.order(:created_at) || []
    @message = Message.new
  end

  def new
    @project = Project.new
  end

  # ✅ Step 1: create project record only, then go to generation page
  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      respond_to do |format|
        format.html { redirect_to generate_project_path(@project), notice: "Projet créé. On passe à la génération." }
        format.turbo_stream { redirect_to generate_project_path(@project), notice: "Projet créé. On passe à la génération." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # ✅ Step 2: display generation page (wizard)
  def generate
    # Ici tu peux afficher un écran de confirmation + bouton “Générer”
    # et éventuellement un aperçu du prompt.
  end

  # ✅ Step 3: run AI once, create chat + first assistant message, then go to discussion
  def kickoff
    chat = current_user.chats.find_or_create_by!(project: @project)

    if chat.messages.none?
      ai_text = kickoff_ai_for(@project)
      chat.messages.create!(
        user: current_user,
        role: "assistant",
        content: ai_text
      )
    end

    redirect_to project_path(@project), notice: "Génération terminée."
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :name,
      :short_description,
      :content,
      :category,
      :duration,
      :level_project,
      :stack
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
      - ...

      ## 3) Architecture / Stack conseillée
      - Front :
      - Back :
      - DB :
      - Auth :
      - Hébergement / Déploiement :

      ## 4) Dream Team (profils + responsabilités + pourquoi)
      Pour chaque profil :
      - Rôle :
      - Missions :
      - Pourquoi c'est utile :
      - Seniorité recommandée :

      ## 5) Roadmap (phases courtes)
      - Phase 1 (Semaine 1) :
      - Phase 2 :
      - Phase 3 :

      ## 6) Risques & quick wins
      - Risques :
      - Quick wins :
    PROMPT

    RubyLLM.chat.ask(prompt).content
  rescue StandardError => e
    "Désolé, l'assistant IA est indisponible pour le moment. (#{e.class})"
  end
end
