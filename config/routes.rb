require "resque/server"

Rails.application.routes.draw do
  mount Resque::Server.new, :at => "/resque"

  resources :forms, path: "f" do
    resources :submissions, only: [:index, :show] do
      post :delete, on: :member
      post :undelete, on: :member
    end
    get :trash, on: :member
    post "", on: :member, to: "submissions#create"
  end

  devise_for :users

  root to: "home#index"
end
