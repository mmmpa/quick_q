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

    scope :on_question, ->(q_ids) { where { question_id.in(q_ids) } }
    scope :tag_counted, -> { group { tag_id }.count { tag_id } }
  end
end
