require 'csv'
#
# 問題に出典を一括登録する。
# createとupdate両用。
#
class TagQToTag
  class << self
    def call(csv_string)
      csv_lines = CSV.parse(csv_string)
      csv_lines.map(&method(:register!))
    end

    def with_way
      tags = {
        in_order: Qa::Tag.find_by(name: :way_in_order),
        free_text: Qa::Tag.find_by(name: :way_free_text),
        ox: Qa::Tag.find_by(name: :way_ox),
        single_choice: Qa::Tag.find_by(name: :way_single_choice),
        multiple_choices: Qa::Tag.find_by(name: :way_multiple_choices),
        multiple_questions: Qa::Tag.find_by(name: :way_multiple_questions)
      }

      Qa::Question.find_each do |q|
        begin
          if q.parent
            q.tags.clear
          else
            tags[q.way.to_sym].questions << q
          end
        rescue => e
          p e
        end
      end
    end

    private

    def register!(line)
      prefix, id, *tags = *line
      name = [prefix, id].compact.join('_')

      begin
        q = Qa::Question.find_by(name: name)

        tags.each do |tag_name|
          begin
            tag = Qa::Tag.find_by(name: tag_name)
            tag.questions << q
          rescue => e
            p e
          end
        end
      rescue => e
        p e
      end
    end
  end
end