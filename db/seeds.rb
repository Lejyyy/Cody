puts "Cleaning database..."
Message.destroy_all
Chat.destroy_all
Project.destroy_all
User.destroy_all

puts "Creating users..."
users = User.create!([
  { email: "user1@test.com", password: "password123" },
  { email: "user2@test.com", password: "password456" }
])

puts "Creating fake dev projects..."

projects = [
  {
    name: "TaskFlow",
    content: "Application SaaS de gestion de tâches avec collaboration en temps réel.",
    level_project: "medium",
    stack: "Ruby on Rails, Hotwire, PostgreSQL, Redis"
  },
  {
    name: "FitTrack",
    content: "Plateforme mobile de suivi sportif avec recommandations personnalisées.",
    level_project: "high",
    stack: "React Native, Node.js, MongoDB"
  },
  {
    name: "ShopEase",
    content: "Mini marketplace avec gestion des stocks et paiement sécurisé.",
    level_project: "medium",
    stack: "Laravel, MySQL, Alpine.js"
  },
  {
    name: "CodeMentor",
    content: "Assistant IA pour aider les développeurs à corriger leur code.",
    level_project: "high",
    stack: "Python, FastAPI, OpenAI API, Redis"
  },
  {
    name: "Evently",
    content: "Application de gestion d'événements avec billetterie intégrée.",
    level_project: "medium",
    stack: "Django, PostgreSQL, TailwindCSS"
  },
  {
    name: "FoodScan",
    content: "App mobile permettant de scanner des produits alimentaires et analyser leur composition.",
    level_project: "low",
    stack: "Flutter, Firebase"
  },
  {
    name: "TravelMate",
    content: "Assistant de voyage proposant des itinéraires personnalisés.",
    level_project: "medium",
    stack: "Next.js, Node.js, Neo4j"
  },
  {
    name: "CryptoWatch",
    content: "Dashboard de suivi des cryptomonnaies en temps réel.",
    level_project: "high",
    stack: "React, Express.js, WebSockets"
  },
  {
    name: "EduQuest",
    content: "Plateforme d'apprentissage gamifiée pour enfants.",
    level_project: "low",
    stack: "Ruby on Rails, Stimulus, PostgreSQL"
  },
  {
    name: "GreenHome",
    content: "Application IoT pour suivre la consommation énergétique d'un foyer.",
    level_project: "high",
    stack: "Go, MQTT, InfluxDB, Grafana"
  }
]

projects.each_with_index do |attrs, i|
  user = users[i % users.length]

  project = Project.create!(
    name: attrs[:name],
    content: attrs[:content],
    level_project: attrs[:level_project],
    stack: attrs[:stack],
    user: user
  )

  # Create chat for the project
  chat = Chat.create!(user: user, project: project)

  # Fake messages
  Message.create!(
    chat: chat,
    user: user,
    role: "user",
    content: "Salut, peux-tu m’aider sur ce projet ?"
  )

  Message.create!(
    chat: chat,
    user: user,
    role: "assistant",
    content: "Bien sûr ! Voici quelques pistes pour commencer."
  )

  Message.create!(
    chat: chat,
    user: user,
    role: "user",
    content: "Super, merci ! Je vais regarder ça."
  )
end

puts "Done! Created #{Project.count} projects, #{Chat.count} chats, #{Message.count} messages."