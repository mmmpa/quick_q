module Qa

  #
  # 問題のみのファサード。
  # 出題に使う。
  #

  class QuestionOnly < Question
    include Pager

    # as_json対策
    has_many :children, -> { order { name } }, class_name: self.name, foreign_key: :question_id

    def as_json(options = {})
      options.merge!(
        only: [:id, :text, :way, :source_link_id, :premise_id]
      )
      super.merge!(detect_options)
    end

    def detect_options
      case
        when free_text?, ox?
          {}
        when in_order?
          {options: options_for_choice, answers_number: correct_answers.count}
        when multiple_questions?
          {children: children.map(&:as_json)}
        else
          {options: options_for_choice}
      end
    end

    def options_for_choice
      answer_options.order { index }.map do |option|
        option.as_json(except: [:question_id])
      end
    end
  end
end
