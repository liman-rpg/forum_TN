Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true
  end

  post '/answers/set_as_best/:id', to: 'answers#set_as_best', as: 'best_answer'

  root to: "questions#index"
end
