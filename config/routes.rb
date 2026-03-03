Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  devise_for :users

  resources :users, only: [:show]

  resources :projects, only: [:index, :show, :new, :create] do
    resources :chats, only: [:create] # create a chat for a project
  end

  resources :chats, only: [:show, :destroy] do
    resources :messages, only: [:create]
  end
end
