Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users

  resources :users, only: [:show]

  resources :projects, only: [:index, :show, :new, :create] do
    member do
      get :generate
      post :kickoff
    end

    resources :chats, only: [:create]
  end
end
