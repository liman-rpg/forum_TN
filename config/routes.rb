Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      post 'set_as_best', on: :member, as: 'best'
    end
  end

  resources :attachments, only: :destroy

  root to: "questions#index"
end
