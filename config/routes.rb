Rails.application.routes.draw do
  namespace :api, format: false do
    scope :q do
      get '', to: 'q#index', as: :questions
      get ':id', to: 'q#show', as: :question
    end

    scope :marks do
      post '', to: 'marks#create', as: :mark
    end
  end

  get '', to: 'portal#index', as: :portal
end
