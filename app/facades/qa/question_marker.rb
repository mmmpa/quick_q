class Qa::QuestionMarker
  def initialize(options = {})
    @q = Qa::Question.find(options[:id])
    @a = options[:answers]
  end

  def mark
    {mark: @q.correct?(normalized_answer), correct_answer: correct_answer}
  end

  def normalized_answer
    case
      when @q.multiple_choices?, @q.in_order?
        @a.map(&:to_i)
      when @q.single_choice?
        @a.to_i
      when @q.multiple_questions?
        @q.children.zip(@a).map do |q, a|
          case
            when q.multiple_choices?, q.in_order?
              a.map(&:to_i)
            when q.single_choice?
              a.to_i
            else
              a
          end
        end
      else
        @a
    end
  end

  def correct_answer
    case
      when @q.free_text?, @q.ox?
        @q.correct_answers.first.text
      when @q.single_choice?
        @q.correct_answers.first.answer_option_id
      when @q.multiple_questions?
        @q.children.zip(@a).map do |q, a|
          case
            when q.free_text?, q.ox?
              q.correct_answers.first.text
            when q.single_choice?
              q.correct_answers.first.answer_option_id
            else
              q.correct_answers.order { index }.pluck(:answer_option_id)
          end
        end
      else
        @q.correct_answers.order { index }.pluck(:answer_option_id)
    end
  end
end