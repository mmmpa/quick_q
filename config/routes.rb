Rails.application.routes.draw do
  namespace :api, format: false do
    scope :q do
      get '', to: 'q#index', as: :questions
      get ':id', to: 'q#show', as: :question
    end
  end
end
