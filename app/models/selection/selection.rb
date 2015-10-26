module Selection

  #
  # 問題集以外の問題セットをあらわすモデル。
  # 点数、合格点はない。正答数のみが得られる。
  #
  # = Attributes choice_type
  #
  # アソシエーション用の値を一時保持する。
  #
  # - manual 指定した問題を取り出す。
  # - random 指定範囲からランダムで指定問題数を取り出す。未実装。
  # - top 未実装
  # - bottom 未実装
  #

  class Selection < ActiveRecord::Base
    enum choice_type: {manual: 10, random: 20, top: 30, bottom: 40}

    has_many :selected_questions, dependent: :destroy
    has_many :questions, class_name: 'Qa::Question', through: :selected_questions

    validates :name, :choice_type,
              presence: true

    validates :choice_type,
              inclusion: {in: Selection.choice_types}

    validate :question_count_correct

    def question_count_correct
      case
        when manual?
          true
        else
          unless questions.size == 0
            errors.add(:questions, :length)
          end
      end
    end
  end
end