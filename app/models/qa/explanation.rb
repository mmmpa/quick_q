module Qa

  #
  # 問題の解説文をあらわすモデル
  # 直接操作はしない
  #
  # # アソシエーション
  #
  # question 自分が属する問題
  #

  class Explanation < ActiveRecord::Base
    belongs_to :question, inverse_of: :explanation
    validates :question, :text,
              presence: true
  end
end
