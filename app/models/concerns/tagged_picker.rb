module TaggedPicker
  def self.included(klass)
    class << klass
      def on(*tag_ids)
        if tag_ids.size == 1
          joins { tags.inner }.where { tags.id == tag_ids.first }
        else
          joins { tags.inner }.where { tags.id.in(tag_ids) }.group { id }.having("COUNT(qa_questions.id) = #{tag_ids.size}")
        end
      end
    end
  end
end