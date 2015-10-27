module Qa

  #
  # とくに普通の問題一覧を表示するときのファサード
  # as_jsonでのパラメーター制御。
  # 将来的にはredisからのカウント取得などがありうる。
  #

  class QuestionIndex < Question
    include Pager

    def as_json(options = {})
      options.merge!(only: [:id, :text])
      super
    end
  end
end
