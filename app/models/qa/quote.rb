module Qa

  #
  # 引用元表示用の交差テーブル。
  #
  # = Associations
  #
  # - question 問題
  # - source_link 引用元
  #

  class Quote < ActiveRecord::Base
    belongs_to :question, inverse_of: :quote
    belongs_to :source_link, inverse_of: :quotes

    validates :question, :source_link,
              presence: true

    validates :question,
              uniqueness: true
  end
end