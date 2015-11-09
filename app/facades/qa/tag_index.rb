module Qa

  #
  # タグ一覧を表示するときのファサード
  # as_jsonでのパラメーター制御。
  # 将来的にはredisからのカウント取得などがありうる。
  #

  class TagIndex < Tag
    class << self
      def index
        Qa::Tag.used
      end

      #
      # 指定されたタグを持つ問題が、どれだけのタグを持っているかカウントする。
      #
      def with_tag(*tag_ids)
        Qa::Tag.on(*tag_ids).used
      end
    end
  end
end
