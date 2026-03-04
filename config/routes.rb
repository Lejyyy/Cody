Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users

  resources :users, only: [:show]

  resources :projects, only: [:index, :show] do
    resources :chats, only: [:create]
  end

  resources :chats, only: [:destroy] do
    resources :messages, only: [:create]
  end
end
