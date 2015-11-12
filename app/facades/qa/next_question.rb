module Qa

  #
  # 問題のみのファサード。
  # 出題に使う。
  #

  class NextQuestion < Question
    default_scope -> { where { question_id == nil }.select { [id, name] }.limit(1) }

    class << self
      def tagged_of(tags, target_id)
        {
          next: on(*tags).order { name }.where { name > Qa::Question.find(target_id).name }.first,
          prev: on(*tags).order { name.desc }.where { name < Qa::Question.find(target_id).name }.first
        }
      end
    end

    def as_json(options = {})
      options.merge!(
        only: [:id]
      )
      super
    end
  end
end
