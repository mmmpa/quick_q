class Exporter
  def initialize
    pp normalized
  end

  def write_export_answers
    CSV.open("#{Rails.root}/log/answers.csv", 'wb') do |csv|
      export_answers.each do |answer|
        csv << answer
      end
    end
  end

  def export_answers
    normalized.select { |q|
      q[:correct_answers].size > 0
    }.map { |q|
      [q[:workbook_key],
       q[:question_index],
       way(q[:way]),
       q[:correct_answers].sort_by { |c|
         c[:index]
       }.map { |c|
         c[:body][:index].to_s
       }.to_json]
    }
  end

  def write_export_questions
    CSV.open("#{Rails.root}/log/questions.csv", 'wb') do |csv|
      export_questions.each do |question|
        csv << question
      end
    end
  end

  def export_questions
    normalized.map { |q|
      [q[:workbook_key],
       q[:question_index],
       way(q[:way]),
       q[:text]]
    }
  end
  
  def write_export_options
    CSV.open("#{Rails.root}/log/options.csv", 'wb') do |csv|
      export_options.each do |option|
        csv << option
      end
    end
  end

  def export_options
    normalized.inject([]) { |aq, q|
      q[:answers].inject(aq) { |aqq, a|
        aqq << [q[:workbook_key],
         q[:question_index],
         a[:index],
         a[:text]]
      }
    }
  end

  def normalized
    Qa::Question
      .includes(:correct_answers, :answer_options, :explanation)
      .all
      .map(&:as_json)
      .map(&:symbolize_keys)
      .map { |hash|
      result = if (name = hash[:name].match(/([0-9]+[a-z_]+)([0-9_]+)/))
                 name
               else
                 hash[:name].match(/([a-z_]+)([0-9_]+)/)
               end
      key = result[1].split('_').compact.join('_')
      hash.merge!(workbook_key: key, question_index: result[2])
    }
  end

  def way(way_string)
    case way_string
      when 'single_choice'
        :single
      when 'multiple_choices'
        :multiple
      when 'in_order'
        :ordered
      when 'ox'
        :single
      when 'free_text'
        :text
      else
        :text
    end
  end
end