#
# webからの入力以外からQa::Questionを作成する
#
# # Usage
#
# CreateQuestion.(hash)
# CreateQuestion.from(json: json)
#

class CreateQuestion
  class << self
    def call(options = {})
      new(options).execute
    end

    def from(options = {})
      case
        when !!options[:json]
          json_hash = JSON.parse(options[:json]).deep_symbolize_keys!
          normalized = normalize_json_hash(json_hash)
          call(questions: normalized)
        else
          raise NoParameter
      end
    end

    def normalize_json_hash(json_hash)
      json_hash[:questions].map! do |question|
        normalize_answer!(question)
        normalize_text!(question)
        normalize_explanation!(question)
        normalize_type!(question)
        normalize_options!(question[:options])
        question
      end
    end

    def normalize_answer!(question)
      return if question[:answers].present?

      question.merge!(answers: question.delete(:answer))
    end

    def normalize_explanation!(question)
      return if question[:explanation_text].present?

      question.merge!(explanation_text: question.delete(:explanation))
    end

    def normalize_text!(question)
      return if question[:text].present?

      question.merge!(text: question.delete(:question)[:text])
    end

    def normalize_type!(question)
      question.merge!(way: detect_way(question.delete(:type)))
    end

    def normalize_options!(options)
      return if options.blank?

      options.map! do |option|
        option.merge!(correct_answer: option.delete(:correct))
      end
    end

    def detect_way(type_text)
      case type_text.to_s.downcase.gsub(' ', '_').to_sym
        when :multiple, :multiple_choices
          Qa::Question.ways[:multiple_choices]
        when :single, :single_choice
          Qa::Question.ways[:single_choice]
        when :ox, :true_or_false
          Qa::Question.ways[:ox]
        when :text, :free_text
          Qa::Question.ways[:free_text]
        when :order, :in_order
          Qa::Question.ways[:in_order]
        else
          raise InvalidType
      end
    end
  end

  def initialize(options = {})
    @questions = options[:questions]
  end

  def create_from_array!
    Qa::Question.transaction do
      result = @questions.inject({models: [], errors: []}) { |a, params|
        begin
          a[:models].push(Qa::Question.create!(params))
        rescue ActiveRecord::RecordInvalid => e
          a[:errors].push(e.record)
        rescue => e
          a[:errors].push(e)
        end
        a
      }

      raise CreationFailed.new(result) if result[:errors].present?
    end
  end

  def execute
    create_from_array! if @questions
  end

  class CreationFailed < StandardError
    def initialize(result)
      @result = result
    end

    def result
      @result
    end
  end

  class InvalidType < StandardError

  end

  class NoParameter < StandardError

  end
end