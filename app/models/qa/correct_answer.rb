module Qa
  class CorrectAnswer < ActiveRecord::Base
    belongs_to :question, inverse_of: :correct_answers
    belongs_to :answer_option, inverse_of: :correct_answers

    validates :question, :answer_option, :index,
              presence: true
  end
end
