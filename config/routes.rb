Rails.application.routes.draw do
  namespace :api, format: false do
    scope :q do
      get '', to: 'q#index', as: :questions
      get 'tagged/-', to: 'q#index', as: :no_tagged_questions
      get 'tagged/:tags', to: 'q#tagged_index', as: :tagged_questions
      get ':id', to: 'q#show', as: :question
      get ':question_id/tag', to: 'tags#with_question', as: :question_tags
    end

    scope :marks do
      post '', to: 'marks#create', as: :mark
    end

    scope :tags do
      get '', to: 'tags#index', as: :tags
      get '2', to: 'tags#index2', as: :tags2
      get 'tagged/:tags', to: 'tags#with_tag', as: :tagged_tag
      get 'tagged/', to: 'tags#index', as: :no_tagged_tag
      get 'tagged/-', to: 'tags#index'
    end

    scope :src do
      get '', to: 'sources#index', as: :sources
      get ':id', to: 'sources#show', as: :source
    end
  end

  get '', to: 'portal#index', as: :portal
  get 'sitemap.txt', to: 'meta#site_map', as: :site_map
  get '*path', to: 'portal#index'
end
