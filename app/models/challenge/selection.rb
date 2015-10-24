module Challenge
  #
  # ある傾向によって選ばれた問題にチャレンジする。
  # 問題はワークブックやカテゴリーからのランダム、完全ランダムなどで選ばれる。
  #
  # = game_state
  #
  # == Keys
  #
  # - name ワークブックの名前や、カテゴリなどのテキスト
  # - questions Qa::Questionのidが配列で保持
  #
  # = challenge_state
  #
  # == Keys
  #
  # - total questionsのsize
  # - index 現在取り組んでいる問題のindex
  # - answers 各問題の解答を配列で保持
  #


  class Selection < Base
    brutal_attributes :brutal_store, :name, :questions, :total, :index, :answers

    aasm do
      state :ready, initial: true
      state :asking_first
      state :asking
      state :asking_last
      state :answered
      state :marked
      state :finished

      event :start do
        transitions from: :ready, to: :asking_first, after: :initialize_challenge!
      end

      event :forward do
        before do
          # indexを一つすすめる
          p self
        end
        transitions from: :asking_first, to: :asking, guard: :not_first?
        transitions from: :asking, to: :asking, guard: :not_last?
        transitions from: :asking, to: :asking_last, guard: :last?
      end

      event :backward do
        # indexを一つもどす
        transitions from: :asking_last, to: :asking
        transitions from: :asking, to: :asking
        transitions from: :asking, to: :asking_first
      end

      event :undo do
        transitions from: :answered, to: :asking_last
      end

      event :finish do
        transitions from: :asking_last, to: :answered
      end

      event :submit do
        transitions from: :answered, to: :marked
      end
    end

    def initialize_challenge!
    end

    def first?

    end

    def last?

    end

    def not_first?
      !first?
    end

    def not_last?
      !last?
    end

    ### accessor

    # challenge_state

    def answer
      answers[index]
    end

    def answer=(value)
      answers[index] = value
    end

    def question
      questions[index]
    end
  end
end