Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post 'vote_up'
      post 'vote_down'
      post 'vote_cancel'
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: { commentable: 'question'}
    resources :answers, shallow: true, concerns: :votable do
      post 'set_as_best', on: :member, as: 'best'
      resources :comments, only: :create, defaults: { commentable: 'answer'}
    end
  end

  resources :attachments, only: :destroy

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
