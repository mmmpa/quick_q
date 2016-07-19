module Qa

  #
  # 正答をあらわすモデル
  # 直接操作はしない
  #
  # # アソシエーション
  #
  # question 自分が属する問題
  # answer_options 自分、つまり正答の内容をあらわす選択肢
  #
  # # index
  #
  # in_order問題では順番も正答である条件になる、
  #

  class CorrectAnswer < ActiveRecord::Base
    belongs_to :question, inverse_of: :correct_answers
    belongs_to :answer_option, inverse_of: :correct_answers

    validates :question, :answer_option, :index,
              presence: true

    def text
      answer_option.text
    end

    def as_json(options = {})
      {
        index: index,
        body: answer_option.as_json
      }
    end
  end
end
