Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users

  resources :users, only: [:show]

  resources :projects, only: [:index, :show, :new, :create] do
    member do
      get :generate
      post :kickoff
    end

    # chat = ressource du projet (1 chat par projet)
    resource :chat, only: [:create, :destroy] do
      resources :messages, only: [:create]
    end
  end
end
