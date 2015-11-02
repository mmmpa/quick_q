module Qa
  class Tag < ActiveRecord::Base

    has_many :questions_tags
    has_many :questions, through: :questions_tags

    validates :name, :display,
              presence: true

    validates :name, :display,
              uniqueness: true
  end
end
