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
    has_many :questions

    validates :name, :url, :display,
              presence: true

    validates :name,
              uniqueness: true
  end
end