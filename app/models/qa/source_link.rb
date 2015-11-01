module Qa

  #
  # 引用元
  #
  # = Associations
  #
  # - question 問題
  # - source_link 引用元
  #

  class SourceLink < ActiveRecord::Base
    has_many :quotes
    has_many :questions, through: :quotes

    validates :name, :url,
              presence: true

    validates :url,
              uniqueness: true
  end
end