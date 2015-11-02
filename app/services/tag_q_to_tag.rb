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