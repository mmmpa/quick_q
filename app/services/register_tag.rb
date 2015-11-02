#
# タグを一括登録する。
# createとupdate両用。
#
class RegisterTag
  class << self
    def call(csv_string)
      csv_lines = CSV.parse(csv_string)
      csv_lines.map(&method(:register!))
    end

    private

    def register!(line)
      prefix, id, *displays = *line
      params = {
        name: [prefix, id].compact.join('_'),
        display: displays.compact.join('::')
      }

      begin
        if (old = Qa::Tag.find_by(name: params[:name]))
          old.update!(params)
        else
          Qa::Tag.create!(params)
        end
      rescue => e
        p e
      end
    end
  end
end