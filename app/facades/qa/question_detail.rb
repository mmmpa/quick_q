module Qa

  #
  # 問題の詳細すべてをはきだすファサード。
  # 編集などに使う。
  # 出題の際は答えを含めない他のファサードを使う。
  #

  class QuestionDetail < Question
    include Pager

    def as_json(options = {})
      options.merge!(
        only: [:id, :name, :text, :way]
      )
      super.merge!(detect_answer)
    end

    def detect_answer
      case
        when free_text?
          {answers: correct_answers.first.text}
        when ox?
          {answers: correct_answers.first.text}
        when in_order?
          {
            options: answer_options,
            order: correct_answers.order { index }.pluck(:answer_option_id)
          }
        else
          {options: answers_for_choice}
      end
    end

    def answers_for_choice
      corrects = Set.new(correct_answers.pluck(:answer_option_id))
      answer_options.map { |option|
        option.as_json(except: [:question_id]).tap do |hash|
          if corrects.include?(option.id)
            hash.merge!(corrent_answer: true)
          end
        end
      }.sort_by { |h|
        h['index']
      }
    end
  end
end
