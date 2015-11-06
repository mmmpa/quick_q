class Qa::QuestionMarker
  def initialize(options = {})
    @q = Qa::Question.find(options[:id])
    @a = options[:answers]
  end

  def mark
    {mark: @q.correct?(normalized_answer), correct_answer: correct_answer_of(@q)}
  end
  
  private

  def normalized_answer_for(answers, for_q)
    case
      when for_q.multiple_choices?, for_q.in_order?
        answers.map(&:to_i)
      when for_q.single_choice?
        answers.to_i
      when for_q.multiple_questions?
        for_q.children.zip(answers).map do |child_q, child_a|
          normalized_answer_for(child_a, child_q)
        end
      else
        answers
    end
  end

  def normalized_answer
    normalized_answer_for(@a, @q)
  end

  def correct_answer_of(q)
    case
      when q.free_text?, q.ox?
        q.correct_answers.first.text
      when q.single_choice?
        q.correct_answers.first.answer_option_id
      when q.multiple_questions?
        q.children.map do |child_q|
          correct_answer_of(child_q)
        end
      else
        q.correct_answers.order { index }.pluck(:answer_option_id)
    end
  end
end