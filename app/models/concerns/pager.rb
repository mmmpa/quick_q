module Pager
  extend ActiveSupport::Concern
  included do
    scope :page, ->(page, par) {
      limit(par).offset((page - 1) * par)
    }
  end
end