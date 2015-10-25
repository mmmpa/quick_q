module Qa

  #
  # 問題の前提文をあらわすモデル
  # 複数の問題で共有される。
  #
  # = Attributes
  #
  # - name このモデルをjsonなど外部入力で特定するときに使う。手動もしくはランダム
  # - text 本文
  #
  # = Associations
  #
  # -pals 前提文共有用の交差テーブル参照
  # -question 自分を参照する問題
  #

  class Premise < ActiveRecord::Base
    has_many :pals, dependent: :destroy
    has_many :questions, through: :pals

    validates :text,
              presence: true

    validates :name,
              uniqueness: true

    def initialize(*)
      super

      self.name ||= SecureRandom.hex(8)
    end
  end
end
