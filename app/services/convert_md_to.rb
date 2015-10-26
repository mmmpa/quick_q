#
# カスタムフォーマットのマークダウンファイルからQa::Questionを生成する
# HashのArrayに整形し、CoordinateQuestionにわたす
#
# = Example
#
#   ConvertMdTo.questions(File.read('questions.md'))
#
#
class ConvertMdTo
  include AASM

  class << self
    def questions(md)
      new(md)
    end
  end

  aasm do
    state :ready, initial: true
    state :format_scanning, enter: :generate_question_hash
    state :question_scanning, exit: :push_question
    state :answers_scanning
    state :answer_scanning, exit: :push_answer
    state :ended, enter: :generate_question_hash

    event :start_format do
      transitions from: :ready, to: :format_scanning
      transitions from: :answers_scanning, to: :format_scanning
      transitions from: :answer_scanning, to: :format_scanning
    end

    event :start_question do
      transitions from: :format_scanning, to: :question_scanning
    end

    event :start_answers do
      transitions from: :question_scanning, to: :answers_scanning
    end

    event :start_answer do
      transitions from: :answers_scanning, to: :answer_scanning
      transitions from: :answer_scanning, to: :answer_scanning
    end

    event :stop do
      transitions from: :answer_scanning, to: :ended
      transitions from: :answers_scanning, to: :ended
    end
  end

  def initialize(md)
    @md = md
    @questions = []
    @buffer = ''
  end

  def execute
    @md.lines.each do |line|
      case line
        when /^#([a-z_0-9]+)\n/
          start_format!
          @now = {
            name: $1
          }
        when "##q\n"
          start_question!
        when "##a\n"
          start_answers!
        when (answers_scanning? || answer_scanning?) && (/^(-)(.*)/ || /^(\+)(.*)/)
          start_answer!
          @correct = $1 == '+'
          @buffer << $2
        when format_scanning? && /##([a-z_0-9]+)\n/
          @now[:way] = $1.to_s.to_sym
        else
          @buffer << line
      end
    end
    stop!
  end

  def stripped_buffer
    @buffer.gsub(/\A[\s\n\r]*/, '').gsub(/[\s\n\r]*\Z/, '')
  end

  def clear_buffer!
    @buffer = ''
  end

  def push_question
    @now[:text] = stripped_buffer
    clear_buffer!
  end

  def push_answer
    @now[:options] ||= []
    @now[:options].push({text: stripped_buffer, correct_answer: @correct})
    clear_buffer!
  end

  def generate_question_hash
    pp @now
    @now = {}
    clear_buffer!
  end
end