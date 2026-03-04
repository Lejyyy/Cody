class MessagesController < ApplicationController
  # rubocop:disable Metrics/MethodLength
  def create
    chat = current_user.chats.find(params[:chat_id])

    user_message = chat.messages.create!(
      user: current_user,
      role: "user",
      content: message_params[:content]
    )

    prompt = build_prompt(chat.project, user_message.content)

    begin
      ai_text = RubyLLM.chat.ask(prompt).content
    rescue StandardError => e
      ai_text = "Désolé, l'assistant IA est indisponible pour le moment. (#{e.class})"
    end

    chat.messages.create!(
      user: current_user,
      role: "assistant",
      content: ai_text
    )

    redirect_to project_path(chat.project)
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def build_prompt(project, user_input)
    <<~PROMPT
      Tu es un assistant IA qui aide un développeur à structurer son projet.

      Contexte du projet (formulaire) :
      - Titre : #{project.name}
      - Catégorie : #{project.category}
      - Durée : #{project.duration}
      - Niveau : #{project.level_project}
      - Stack : #{project.stack}
      - Short description : #{project.short_description}
      - Long description : #{project.content}

      Message utilisateur :
      #{user_input}

      Réponds de façon structurée :
      1) Compréhension du besoin
      2) Suggestions produit (MVP puis évolutions)
      3) Stack & architecture recommandée
      4) Profils nécessaires / roadmap
      5) Risques + quick wins
    PROMPT
  end
end
# rubocop:enable Metrics/MethodLength
