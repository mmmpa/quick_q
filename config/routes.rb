Rails.application.routes.draw do
  namespace :api, format: false do
    scope :q do
      get '', to: 'q#index', as: :questions
      get 'tagged/:tags', to: 'q#tagged_index', as: :tagged_questions
      get ':id', to: 'q#show', as: :question
    end

    scope :marks do
      post '', to: 'marks#create', as: :mark
    end

    scope :tags do
      get '', to: 'tags#index', as: :tags
    end
  end

  get '', to: 'portal#index', as: :portal
  get '*path', to: 'portal#index'
end
