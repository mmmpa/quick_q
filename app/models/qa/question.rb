module Qa
  class Question < ActiveRecord::Base
    BOOLEAN_O = 'o'
    BOOLEAN_X = 'x'

    enum way: {free_text: 10, boolean: 20, choice: 30, choices: 40, in_order: 50}

    has_many :correct_answers, dependent: :destroy
    has_many :answer_options, dependent: :destroy

    validates :text, :way,
              presence: true

    validate :way_requirement_fulfilled, if: -> { correct_answers.present? }

    # 答え合わせ
    def correct?(answer)
      normalized = normalized_answer(answer)

      case
        when boolean?
          matcher = normalized_boolean(answer) ? BOOLEAN_O : BOOLEAN_X
          correct_answers.first.answer_option.text == matcher
        when in_order?
          # 順序まで完全に同じか
          correct_answers.pluck(:answer_option_id) == normalized
        else
          # 正答のみが含まれているか
          corrects = correct_set
          normalized.size == corrects.size && Set.new == (corrects - Set.new(normalized))
      end
    end

    def arrange_for_free_text!(correct_answer:)
      free_text!
      sweep!
      new_answer = answer_options.build(text: correct_answer)
      correct_answers.build(answer_option: new_answer)
      save!

      self
    end

    def arrange_for_boolean!(correct_answer:)
      boolean!
      sweep!
      o = answer_options.build(text: BOOLEAN_O)
      x = answer_options.build(text: BOOLEAN_X)
      correct_answers.build(answer_option: correct_answer ? o : x)
      save!

      self
    end

    private

    def correct_answers_included?
      corrects = correct_set
      options = option_set

      corrects == (corrects & options)
    end

    def correct_answers_length_valid?
      case
        when free_text?, choice?
          correct_answers.size == 1
        when boolean?
          correct_answers.size == 1
        when choices?, in_order?
          correct_answers.size <= answer_options.size
        else
          correct_answers.size > 1
      end
    end

    def correct_set
      Set.new(correct_answers.pluck(:answer_option_id))
    end

    def normalized_answer(answer)
      if free_text?
        answer_options.where { text == answer }.pluck(:id)
      else
        Array.wrap(answer)
      end
    end

    def normalized_boolean(boolean)
      return boolean if TRUE === boolean || FALSE === boolean

      case boolean.to_s.downcase
        when 'true', '1'
          true
        else
          false
      end
    end

    def option_set
      Set.new(answer_options.pluck(:id))
    end

    def way_requirement_fulfilled
      unless correct_answers_included?
        errors.add(:correct_answers, :inclusion)
      end

      unless correct_answers_length_valid?
        errors.add(:correct_answers, :length)
      end
    end

    def sweep!
      correct_answers.destroy_all
      answer_options.destroy_all
    end
  end
end
