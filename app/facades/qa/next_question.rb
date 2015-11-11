module Qa

  #
  # 問題のみのファサード。
  # 出題に使う。
  #

  class NextQuestion < Question
    default_scope -> { where { question_id == nil }.order { name } }

    class << self
      def of(target_id)
        tags = Qa::Tag.joins { questions_tags }
                 .where { questions_tags.question_id == target_id }

        sub = joins { questions_tags }
                .where { questions_tags.tag_id.in(tags.select { :id }) }
                .where { name > Qa::Question.find(target_id).name }
                .select { ['qa_questions.*', questions_tags.tag_id.as(:tag_id)] }
                .to_a
                .uniq { |r| r.tag_id }
      end

      def of2(target_id)
        tags = Qa::Tag.joins { questions_tags }
                 .where { questions_tags.question_id == target_id }
                 .select { [id, display] }
        sub = joins { questions_tags }
                .where { questions_tags.tag_id.in(tags.pluck(:id)) }
                .where { name > Qa::Question.where { id == target_id }.first.name }

        next_qs = tags.pluck(:id, :display).map do |tag_id, display|
          {
            display: display,
            question: sub.where { questions_tags.tag_id == tag_id }.offset(1).limit(1).first
          }
        end
      end
    end

    def as_json(options = {})
      options.merge!(
        only: [:id, :tag_id]
      )
      super.merge!(text: text[0..30])
    end
  end
end
