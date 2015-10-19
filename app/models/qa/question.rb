class Qa::Question < ActiveRecord::Base
  enum ways: {free_text: 10, boolean: 20, choice: 30, choices: 40, in_order: 50}

  has_many :correct_answers, class_name: 'Qa::CorrectAnswer', foreign_key: :qa_question_id
  has_many :answer_options, class_name: 'Qa::AnswerOption', foreign_key: :qa_question_id

  validates :text, :way,
    presence: true
end
