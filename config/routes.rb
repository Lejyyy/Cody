Rails.application.routes.draw do
  root to: "pages#home"

  resources :users, only: [:show]

  resources :projects, only: [:index, :show] do
    resources :chat, only: [:show, :create]
  end

  devise_for :users

  resources :chats, only: [:destroy] do
    resources :messages, only: [:create]
  end
end