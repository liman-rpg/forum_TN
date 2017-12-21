Rails.application.routes.draw do
  use_doorkeeper
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

  namespace :api do
    namespace :v1 do
      resource :profiles, only: [:me, :index] do
        get :me, on: :collection
        get :index, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:show, :create], shallow: true
        get :answers, to: 'questions#answers', on: :member
      end
    end
  end

  get 'omniauth_services/request_email', to: 'omniauth_services#request_email', as: :request_email
  post 'omniauth_services/save_email', to: 'omniauth_services#save_email', as: :save_email
  get 'omniauth_services/confirm_email', to: 'omniauth_services#confirm_email', as: :confirm_email

  resources :attachments, only: :destroy

  root to: "questions#index"

  mount ActionCable.server => '/cable'

end
