module Qa
  class Tagged < Question
    class << self
      def on(*tag_ids)
        if tag_ids.size == 1
          joins { tags }.where { tags.id == tag_ids.first }
        else
          joins { tags }.where { tags.id.in(tag_ids) }.group(:id).having('COUNT("qa_questions"."id")=' + tag_ids.size.to_s)
        end
      end
    end
  end
end