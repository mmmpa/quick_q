module Qa
  class Question < ActiveRecord::Base
    BOOLEAN_O = 'o'
    BOOLEAN_X = 'x'

    attr_accessor :answers, :options

    enum way: {free_text: 10, boolean: 20, choice: 30, choices: 40, in_order: 50}

    has_many :correct_answers, dependent: :destroy
    has_many :answer_options, dependent: :destroy

    validates :text, :way,
              presence: true

    validate :way_requirement_fulfilled, if: -> { correct_answers.present? }

    before_validation :arrange!

    #
    # フリーテキスト、ox問題の場合はcorrectsがcorrect_answersとanswer_optionsに
    # ダイレクトに反映される
    #
    def arrange!
      case
        when free_text?
          arrange_for_free_text!
        when boolean?
          arrange_for_boolean!
        else
          arrange_for_choice_way!
      end

      true
    end

    # 選択系すべて
    def arrange_for_choice_way!
      return if options.blank?

      # 現在の選択肢と比較してなくなっている分を削除
      now = Set.new(answer_options.pluck(:id))
      newer = options.map { |o| o[:id] }
      (now - newer).each { |id| answer_options.destroy(id) }

      # idがあるものはupdate、無いものはnew
      options.each do |param|
        if param[:id].present?
          answer_options.find(param.delete(:id)).update!(params)
        else
          answer_options.build(param)
        end
      end

      # 毎回更新
      correct_answers.delete_all
      answers.each_with_index do |param, index|
        # 保存前にはSQLが絡むメソッドは使えない
        # 見つからないと配列が返ってしまう
        option = answer_options.each do |answer|
          break answer if answer.index == param[:index]
        end
        if Array === option
          errors.add(:answers, :invalid)
        else
          correct_answers.build(answer_option: option, index: index)
        end
      end

      self
    end

    def arrange_for_free_text!
      if answers.blank?
        errors.add(:answers, :blank)
        return
      end

      sweep!
      new_answer = answer_options.build(text: stripped_answers)
      correct_answers.build(answer_option: new_answer)

      self
    end

    def arrange_for_boolean!
      if answers.blank?
        errors.add(:answers, :blank)
        return
      end

      sweep!
      o = answer_options.build(text: BOOLEAN_O)
      x = answer_options.build(text: BOOLEAN_X)
      correct_answers.build(answer_option: normalized_boolean(stripped_answers) ? o : x)

      self
    end

    # 答え合わせ
    def correct?(answer)
      normalized = normalized_answer(answer)

      case
        when boolean?
          matcher = normalized_boolean(answer) ? BOOLEAN_O : BOOLEAN_X
          correct_answers.first.answer_option.text == matcher
        when in_order?
          # 順序まで完全に同じか
          correct_answers.order { index }.pluck(:answer_option_id) == normalized
        else
          # 正答のみが含まれているか
          corrects = correct_set
          normalized.size == corrects.size && Set.new == (corrects - Set.new(normalized))
      end
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
        when choices?
          correct_answers.size <= answer_options.size
        else
          correct_answers.size >= 1
      end
    end

    def correct_set
      Set.new(correct_answers.pluck(:answer_option_id))
    end

    def stripped_answers
      return answers unless Array === answers

      answers.first
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

    def sweep!
      correct_answers.destroy_all
      answer_options.destroy_all
    end

    def way_requirement_fulfilled
      unless correct_answers_included?
        errors.add(:correct_answers, :inclusion)
      end

      unless correct_answers_length_valid?
        errors.add(:correct_answers, :length)
      end
    end

  end
end
