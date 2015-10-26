module Qa

  #
  # 問題の前提文を共有するための交差テーブル。
  # 問題文は一つの前提文しか持てないのでユニーク。
  # 前提文は複数の問題にひもづくのでinverseで複数形となる
  #
  # = Associations
  #
  # - question 問題
  # - premise 前提
  #

  class Pal < ActiveRecord::Base
    belongs_to :question, inverse_of: :pal
    belongs_to :premise, inverse_of: :pals

    validates :question, :premise,
              presence: true

    validates :question,
              uniqueness: true
  end
end
