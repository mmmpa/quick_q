module Qa

  #
  # 問題の詳細すべてをはきだすファサード。
  # 編集などに使う。出題の際は答えを含めない他のファサードを使う。
  #

  class QuestionDetail < Question
    include Pager

    def as_json(options = {})
      options.merge!(
        only: [:id, :name, :text, :way]
      )
      super.merge!(detect_options)
    end

    def detect_options
      case
        when free_text?, ox?
          {}
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
