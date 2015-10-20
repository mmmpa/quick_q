module Qa
  #
  # 問題の選択肢をあらわすモデル
  # 直接操作はしない
  #
  # # アソシエーション
  #
  # question 自分が属する問題
  # correct_answers 自分を参照する正答。inverse_of対応のため
  #
  # # index
  #
  # 表示順の他に、新規作成時にはidではなくindexを手がかりとして
  # CorrectAnswerが作成されるため必要
  #

  class AnswerOption < ActiveRecord::Base
    belongs_to :question, inverse_of: :correct_answers
    has_many :correct_answers

    validates :question, :text, :index,
              presence: true
  end
end
