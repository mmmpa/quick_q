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

    def from_json(options = {})
      hash = case
               when !!options[:json]
                 JSON.parse(options[:json])
               else
                 raise NoParameter
             end

      hash.deep_symbolize_keys!
      call(**hash)
    end
  end

  def initialize(options = {})
    pp options
  end

  def execute

  end

  class NoParameter < StandardError

  end
end