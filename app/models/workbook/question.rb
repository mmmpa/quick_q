module Workbook
  class Question < ActiveRecord::Base
    belongs_to :book
    belongs_to :question, class_name: Qa::Question

    validates :score, :book, :question,
              presence: true

    validates :book,
              uniqueness: {
                scope: :question
              }
  end
end
