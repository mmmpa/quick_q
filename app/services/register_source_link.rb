#
# webからの入力以外からQa::Questionを作成する
#
# = Example
#
#   CoordinateQuestion.from(json: json)
#   CoordinateQuestion.from(csv: json, way: :in_order)
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

      if (old = Qa::SourceLink.find_by(name: params[:name]))
        old.update!(params)
      else
        Qa::SourceLink.create!(params)
      end
    end
  end
end