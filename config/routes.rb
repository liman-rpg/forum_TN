Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true
  end

  root "questions#index"
end
