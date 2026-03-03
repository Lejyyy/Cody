class MessagesController < ApplicationController
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

    Projet :
    - Titre : #{project.title}
    - Description : #{project.description}

    Message utilisateur :
    #{user_input}

    Réponds de façon structurée :
    1. Compréhension du besoin
    2. MVP conseillé
    3. Stack recommandée
    4. Profils nécessaires
    5. Risques & quick wins
    PROMPT
  end
end
