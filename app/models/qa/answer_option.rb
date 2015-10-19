class Qa::AnswerOption < ActiveRecord::Base
  belongs_to :question, class_name: 'Qa::Question', foreign_key: :qa_question_id, inverse_of: :correct_answers

  validates :question, :text, :index,
            presence: true
end
