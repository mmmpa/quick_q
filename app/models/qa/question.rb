module Qa
  class Question < ActiveRecord::Base
    enum ways: {free_text: 10, boolean: 20, choice: 30, choices: 40, in_order: 50}

    has_many :correct_answers
    has_many :answer_options

    validates :text, :way,
              presence: true
  end
end
