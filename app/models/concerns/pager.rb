module Pager
  extend ActiveSupport::Concern
  included do
    scope :page, ->(page, par) { limit(par).offset((page - 1) * par) }
    scope :newer_page, ->(page, par) { page(page, par).order { updated_at.desc } }
    scope :older_page, ->(page, par) { page(page, par).order { updated_at } }
  end
end