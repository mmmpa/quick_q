module Qa
  class AnswerOption < ActiveRecord::Base
    belongs_to :question, inverse_of: :correct_answers

    validates :question, :text, :index,
              presence: true
  end
end
