module Qa

  #
  # とくに普通の問題一覧を表示するときのファサード
  # as_jsonでのパラメーター制御。
  # 将来的にはredisからのカウント取得などがありうる。
  #
  # 親持ちの問題は除外される
  #

  class QuestionIndex < Question
    include Pager

    default_scope -> { where { question_id == nil } }

    def as_json(options = {})
      options.merge!(only: [:id, :text, :way])
      super
    end

    class << self
      def header_information(page, per)
        {
          'Total-Pages' => (normalized_count.to_f / per).ceil.to_s,
          'Per-Page' => per.to_s,
          'Current-Page' => page.to_s,
        }
      end

      private

      def normalized_count
        return count unless Hash === count
        count.keys.size
      end
    end
  end
end
