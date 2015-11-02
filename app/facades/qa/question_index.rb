module Qa

  #
  # とくに普通の問題一覧を表示するときのファサード
  # as_jsonでのパラメーター制御。
  # 将来的にはredisからのカウント取得などがありうる。
  #

  class QuestionIndex < Question
    include Pager
    include TaggedPicker

    def as_json(options = {})
      options.merge!(only: [:id, :text, :way])
      super
    end

    class << self
      def header_information(page, per)
        {
          'Total-Pages' => (count / per).to_s,
          'Per-Page' => per.to_s,
          'Current-Page' => page.to_s,
        }
      end
    end
  end
end
