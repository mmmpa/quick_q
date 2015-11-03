module Qa

  #
  # タグ一覧を表示するときのファサード
  # as_jsonでのパラメーター制御。
  # 将来的にはredisからのカウント取得などがありうる。
  #

  class TagIndex < Tag

    # brutal_indexのカウント数保持
    attr_accessor :counted

    class << self
      #
      # 乱暴だけどとりあえず速い
      #
      def brutal_index
        stored_count = Qa::QuestionsTag.group { tag_id }.count { tag_id }
        all.order { name }.map { |r| r.counted = stored_count[r.id].to_i; r }
      end

      #
      # 1クエリで決まってスマートっぽい
      #
      def index
        joins { questions_tags.outer }
          .select('qa_tags.*, COUNT(qa_questions_tags.id) AS ar_counted').group { id }.order { name }
      end

      #
      # 指定されたタグを持つ問題が、どれだけのタグを持っているかカウントする。
      #
      def with_tag(*tag_ids)
        q_ids_sub_query = Qa::QuestionIndex.on(*tag_ids).select(:id)
        stored_count = Qa::QuestionsTag.where { question_id.in(q_ids_sub_query) }.group { tag_id }.count { tag_id }
        all.order { name }.map { |r| r.counted = stored_count[r.id].to_i; r }
      end
    end

    def as_json(options = {})
      options.merge!(only: [:id, :display])
      super.merge!(
        count: (counted || try(:ar_counted)).to_i # なにかあっても最低限0になる
      )
    end
  end
end
