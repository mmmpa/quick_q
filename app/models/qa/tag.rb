module Qa
  class Tag < ActiveRecord::Base
    # brutal_indexのカウント数保持
    attr_accessor :counted

    has_many :questions_tags
    has_many :questions, through: :questions_tags

    validates :name, :display,
              presence: true

    validates :name, :display,
              uniqueness: true

    scope :used, -> {
      joins { questions_tags.outer }
        .select { ['qa_tags.*', count(questions_tags.id).as(count)] }
        .group { id }
    }

    scope :on, ->(*tag_ids) {
      joins { questions_tags.outer }
        .where { questions_tags.question_id.in(Qa::Question.on(tag_ids).select { id }) }
    }

    def as_json(options = {})
      options.merge!(only: [:id, :display])
      super.merge!(
        count: (counted || try(:count)).to_i # なにかあっても最低限0になる
      )
    end
  end
end
