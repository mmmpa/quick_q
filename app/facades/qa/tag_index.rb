module Qa

  #
  # タグ一覧を表示するときのファサード
  # as_jsonでのパラメーター制御。
  # 将来的にはredisからのカウント取得などがありうる。
  #

  class TagIndex < Tag
    class << self
      attr_accessor :stored_count

      def with_count
        self.stored_count = Qa::QuestionsTag.group { tag_id }.count { tag_id }
        all
      end
    end

    def as_json(options = {})
      options.merge!(only: [:id, :display])
      super.merge!(
        count: self.class.stored_count.try(:[], id) || 0
      )
    end
  end
end
