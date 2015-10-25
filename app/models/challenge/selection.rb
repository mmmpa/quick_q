module Challenge
  #
  # ある傾向によって選ばれた問題にチャレンジする。
  # 問題はワークブックやカテゴリーからのランダム、完全ランダムなどで選ばれる。
  # 現段階では問題が1問のみの状態には対応していない。
  #
  # = State Machine State
  #
  # - ready このモデル作成直後の状態。問題などは揃っている。
  # - asking 問題の出題
  # - asked 全て解答を終えた状態
  # - marked 採点を終えた状態
  #
  # = Attributes
  #
  # - name ワークブックの名前や、カテゴリなどのテキスト
  # - questions Qa::Questionのidが配列で保持
  # - total questionsのsize
  # - index 現在取り組んでいる問題のindex
  # - answers 各問題の解答を配列で保持
  # - workbook_id Workbookモードの場合は指定
  # - selection_id Selectionモードの場合は指定
  #
  # = Challenge::Selection#new
  #
  # = Options
  #
  # - name ワークブックの名前や、カテゴリなどのテキスト
  # - questions Qa::Questionのidが配列で保持
  # - workbook_id Workbookモードの場合は指定
  # - selection_id Selectionモードの場合は指定
  #
  # == Example
  #
  #   # Workbookモード
  #   Selection.new(name: 'サンプル問題集', questions: [1, 2, 3, 4, 5, 6, 7, 8, 9, 19], workbook_id: 1)
  #
  #   # Selectionモード
  #   Selection.new(name: 'ランダム5問', questions: [3, 7, 5, 2, 1], selection_id: 2)
  #

  class Selection < Base
    brutal_attributes :brutal_store,
                      :name, :questions, :total, :index, :answers,
                      :selection_id, :workbook_id

    aasm do
      state :ready, initial: true, exit: :verify_required
      state :asking
      state :asked, enter: :verify_all_answered
      state :marked

      event :start do
        transitions from: :ready, to: :asking

        after do
          save
        end
      end

      event :finish do
        transitions from: :asking, to: :asked

        after { save }
      end

      event :undo do
        transitions from: :asked, to: :asking

        after { save }
      end

      event :submit do
        transitions from: :asked, to: :marked

        after { save }
      end
    end

    def initialize_challenge!
      self.index = 0
      self.answers = []
    end

    def start_with!(name: nil, questions: nil, selection_id: nil, workbook_id: nil)
      self.name = name
      self.selection_id = selection_id
      self.workbook_id = workbook_id
      self.questions = questions || []
      self.total = self.questions.size

      initialize_challenge!

      start!
    end

    def verify_required
      unless name.present? && (selection_id.present? || workbook_id.present?) && questions.present? && total.present?
        raise MissingRequiredParameters
      end
    end

    def verify_all_answered
      raise NotYetAnsweredAll if total > answers.size
      answers.each do |answer|
        raise NotYetAnsweredAll if answer.blank?
      end
    end

    def answer_and_forward!(answer)
      self.answer = answer
      increment_index!
      save
    rescue IndexOver
      finish!
    end

    def backward!
      decrement_index!
      save
    rescue IndexOver
      nil
    end

    def increment_index!
      raise IndexOver if last?
      self.index += 1
    end

    def decrement_index!
      raise IndexOver if first?
      self.index -= 1
    end

    def first?
      index == 0
    end

    def last?
      index + 1 == total
    end

    def answer
      answers[index]
    end

    def answer=(value)
      raise NotYetStarted if ready?
      raise AllQuestionsAsked if asked? || marked?
      answers[index] = value
    end

    def question
      raise NotYetStarted if ready?
      raise AllQuestionsAsked if asked? || marked?
      questions[index]
    end

    class IndexOver < StandardError

    end

    class MissingRequiredParameters < StandardError

    end

    class NotYetStarted < StandardError

    end

    class NotYetAnsweredAll < StandardError

    end

    class AllQuestionsAsked < StandardError

    end
  end
end