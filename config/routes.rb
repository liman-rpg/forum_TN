Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

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

  get 'omniauth_services/request_email', to: 'omniauth_services#request_email', as: :request_email
  post 'omniauth_services/save_email', to: 'omniauth_services#save_email', as: :save_email
  get 'omniauth_services/confirm_email', to: 'omniauth_services#confirm_email', as: :confirm_email

  resources :attachments, only: :destroy

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
