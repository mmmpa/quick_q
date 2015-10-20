module Qa
  class Question < ActiveRecord::Base
    enum way: {free_text: 10, boolean: 20, choice: 30, choices: 40, in_order: 50}

    has_many :correct_answers, dependent: :destroy
    has_many :answer_options, dependent: :destroy

    validates :text, :way,
              presence: true

    validate :include_correct_answers, if: -> { correct_answers.present? }

    # 正答が選択肢に含まれているか
    def include_correct_answers
      corrects = correct_set
      options =  option_set

      unless corrects == (corrects & options)
        errors.add(:correct_answers, :inclusion)
      end
    end

    def correct?(ids)
      if in_order?
        # 同じ順序か
        correct_answers.pluck(:answer_option_id) == ids
      else
        # 正答のみが含まれているか
        corrects = correct_set
        ids.size == corrects.size && Set.new == (corrects - Set.new(ids))
      end
    end

    private

    def correct_set
      Set.new(correct_answers.pluck(:answer_option_id))
    end

    def option_set
      Set.new(answer_options.pluck(:id))
    end
  end
end
