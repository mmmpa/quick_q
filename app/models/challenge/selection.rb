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

    def initialize(options = {})
      super
    end

    def initialize_challenge!
      super
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

    def stored_challenge_state
      @stored_cs ||= challenge_state.to_h
    end

    def index
      stored_challenge_state['index'].to_i
    end

    def index=(value)
      @stored_cs = nil
      challenge_state['index'] = value
    end

    def total
      stored_challenge_state['total'].to_i
    end

    def total=(value)
      @stored_cs = nil
      challenge_state['total'] = value
    end

    def answer
      answers[index]
    end

    def answer=(value)
      read_answers = answers
      read_answers[index] = value
      self.answers= read_answers
    end

    def answers
      JSON.parse(stored_challenge_state['answers']) rescue []
    end

    def answers=(value)
      @stored_cs = nil
      challenge_state['answers'] = JSON.generate(value)
    end

    # game_state

    def stored_game_state
      @stored_gs ||= game_state.to_h
    end

    def name
      stored_game_state['name']
    end

    def name=(value)
      @stored_gs = nil
      game_state['name'] = value
    end

    def question
      questions[index]
    end

    def questions
      JSON.parse(stored_game_state['questions']) rescue []
    end

    def questions=(value)
      @stored_gs = nil
      game_state['questions'] = JSON.generate(value)
    end
  end
end