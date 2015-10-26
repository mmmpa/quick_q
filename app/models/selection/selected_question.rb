module Selection

  #
  # 問題集と問題をひもづける。
  #
  # = Associations
  #
  # - selection セレクション
  # - question 問題本体
  #

  class SelectedQuestion < ActiveRecord::Base
    belongs_to :selection, inverse_of: :selected_questions
    belongs_to :question, class_name: 'Qa::Question', inverse_of: :selected

    validates :question, :selection,
              presence: true

    validates :selection,
              uniqueness: {scope: :question}
  end
end
