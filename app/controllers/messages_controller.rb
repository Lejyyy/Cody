class MessagesController < ApplicationController
  def create
    chat = current_user.chats.find(params[:chat_id])

    user_msg = chat.messages.create!(
      user: current_user,
      role: "user",
      content: params.require(:message).fetch(:content)
    )

    prompt = build_prompt(chat.project, user_msg.content)

    ai_text = RubyLLM.chat.ask(prompt).content

    chat.messages.create!(
      user: current_user,
      role: "assistant",
      content: ai_text
    )

    redirect_to chat_path(chat)
  end

  private

  def build_prompt(project, user_content)
    <<~PROMPT
      Tu es un assistant IA pour développeur web. Contexte projet :
      - Titre : #{project.title}
      - Description : #{project.description}
      - Objectif : #{project.goal}
      - Stack actuelle : #{project.stack}

      Message utilisateur :
      #{user_content}

      Réponds de façon structurée :
      1) Compréhension du besoin
      2) Suggestions produit (MVP puis évolutions)
      3) Stack & architecture recommandée
      4) Profils nécessaires / roadmap
      5) Risques + quick wins
    PROMPT
  end
end
