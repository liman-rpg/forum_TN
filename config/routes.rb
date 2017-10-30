Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    post 'vote_up', on: :member, as: 'vote_up'
    post 'vote_down', on: :member, as: 'vote_down'
    resources :answers, shallow: true do
      post 'set_as_best', on: :member, as: 'best'
    end
  end

  resources :attachments, only: :destroy

  root to: "questions#index"
end
