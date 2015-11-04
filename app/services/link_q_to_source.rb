require 'csv'
#
# 問題に出典を一括登録する。
# createとupdate両用。
#
class LinkQToSource
  class << self
    def call(csv_string)
      csv_lines = CSV.parse(csv_string)
      csv_lines.map(&method(:register!))
    end

    private

    def register!(line)
      prefix, id, source_name = *line
      name = [prefix, id].compact.join('_')

      q = Qa::Question.find_by(name: name)
      source_link = Qa::SourceLink.find_by(name: source_name)

      begin
        q.update!(source_link: source_link)
      rescue => e
        p e
      end
    end
  end
end