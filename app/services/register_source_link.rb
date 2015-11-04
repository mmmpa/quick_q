require 'csv'
#
# 出典を一括登録する。
# createとupdate両用。
#
class RegisterSourceLink
  class << self
    def call(csv_string)
      csv_lines = CSV.parse(csv_string)
      csv_lines.map(&method(:register!))
    end

    private

    def register!(line)
      prefix, id, url, *displays = *line
      params = {
        name: [prefix, id].compact.join('_'),
        url: url,
        display: displays.compact.join('::')
      }

      begin
        if (old = Qa::SourceLink.find_by(name: params[:name]))
          old.update!(params)
        else
          Qa::SourceLink.create!(params)
        end
      rescue => e
        p e
      end
    end
  end
end