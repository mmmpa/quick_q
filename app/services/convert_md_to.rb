#
# カスタムフォーマットのマークダウンファイルからQa::Questionを生成する
# HashのArrayに整形し、CoordinateQuestionにわたす
#
# = Example
#
#   ConvertMdTo.questions(File.read('questions.md')).execute
#
#
class ConvertMdTo
  include AASM

  class << self
    def questions(md, options = {})
      new(md, options.merge!(question: true))
    end

    def premises(md, options = {})
      new(md, options.merge!(premise: true))
    end
  end

  aasm do
    state :ready, initial: true
    state :format_scanning, enter: :generate_question_hash
    state :question_scanning, exit: :push_question
    state :answers_scanning
    state :answer_scanning, exit: :push_answer
    state :ended, enter: :generate_question_hash

    state :premise_naming, enter: :generate_premise_hash
    state :premise_scanning, exit: :push_premise
    state :premise_ended, enter: :generate_premise_hash

    event :start_premise_name do
      transitions from: :ready, to: :premise_naming
      transitions from: :premise_scanning, to: :premise_naming
    end

    event :start_premise do
      transitions from: :premise_naming, to: :premise_scanning
    end

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
      transitions from: :premise_scanning, to: :premise_ended

      after do
        convert!
      end
    end
  end

  def initialize(md, options = {})
    @md = md
    @questions = []
    @update = !!options[:update]
    @mode = if options[:question]
              :q
            elsif options[:premise]
              :p
            end

    init_params_store!
    clear_buffer!
  end

  def question?
    @mode == :q
  end

  def premise?
    @mode == :p
  end

  def convert!
    if question?
      CoordinateQuestion.new(questions: @questions.compact, update: @update).execute
    elsif premise?
      @questions.each do |premise|
        if old = Qa::Premise.find_by(name: premise[:name])
          old.update!(premise)
        else
          Qa::Premise.create!(premise)
        end
      end
    end
  rescue => e
    e.result[:errors].each do |record|
      begin
        pp record.errors
      rescue
        pp record
      end
    end
  end

  def execute
    @md = @md.gsub("\r", '')
    @md.lines.each do |line|
      if question?
        case line
          when /^#([a-z_0-9]+)\n/i
            start_format!
            @now = {
              name: $1
            }
          when /^##to:([a-z_0-9]+)\n/i
            @now[:to] = $1
          when /^##src:([a-z_0-9]+)\n/i
            @now[:source_link] = Qa::SourceLink.find_by(name: $1)
          when /^##tags:([a-z_0-9,]+)\n/i
            @now[:tags] = $1.split(',').map do |tag_name|
              Qa::Tag.find_by(name: tag_name)
            end
          when /^##order_a:([\s0-9,]+)\n/i
            @now[:order] = $1.split(',').map(&:to_i)
          when /^##premise:([a-z_0-9]+)\n/i
            @now[:premise] = Qa::Premise.find_by(name: $1)
          when "##q\n", "##Q\n"
            start_question!
          when "##a\n", "##A\n"
            start_answers!
            start_answer! if no_options?
          when (answers_scanning? || answer_scanning?) && /^(-|\+)(.*)/
            start_answer!
            @correct = $1 == '+'
            @buffer << $2
          when format_scanning? && /##([a-z_0-9]+)\n/
            @now[:way] = Qa::Question.ways[$1.to_s.to_sym]
          else
            @buffer << line
        end
      elsif premise?
        case line
          when /^#([a-z_0-9]+)\n/i
            start_premise_name!
            @now = {
              name: $1
            }
          when "##p\n", "##P\n"
            start_premise!
          else
            @buffer << line
        end
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

  def push_premise
    @now[:text] = stripped_buffer
    clear_buffer!
  end

  def no_options?
    @now[:way] == Qa::Question.ways[:free_text] || @now[:way] == Qa::Question.ways[:ox]
  end

  def push_answer
    if no_options?
      @now[:answers] = @buffer
    else
      @now[:options] ||= []
      @now[:options].push({text: stripped_buffer, correct_answer: @correct})
    end

    clear_buffer!
  end

  def add_params!
    @questions.push(@now) if @now != {}
  end

  def init_params_store!
    @now = {}
  end

  def generate_question_hash
    add_params!
    init_params_store!
    clear_buffer!
  end

  def generate_premise_hash
    add_params!
    init_params_store!
    clear_buffer!
  end
end