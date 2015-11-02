module Qa
  class QuestionsTag < ActiveRecord::Base
    belongs_to :question, inverse_of: :questions_tags
    belongs_to :tag, inverse_of: :questions_tags

    validates :question, :tag,
              presence: true

    validates :question,
              uniqueness: {
                scope: :tag
              }
  end
end
