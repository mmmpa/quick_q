module Workbook
  class Book < ActiveRecord::Base
    validates :name, :eval_type, :passing,
              presence: true
  end
end
