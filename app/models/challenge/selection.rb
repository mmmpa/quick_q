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
      state :asked
      state :marked
      state :finished

      event :start do
        transitions from: :ready, to: :asking_first

        after do
          initialize_challenge!
          save
        end
      end

      event :forward, if: :fowardable? do
        transitions from: :asking_first, to: :asking
        transitions from: :asking, to: :asking_last, if: :next_index_last?
        transitions from: :asking, to: :asking

        after do
          increment_index!
          save
        end
      end

      event :backward do
        transitions from: :asking_last, to: :asking
        transitions from: :asking, to: :asking_first, if: :prev_index_first?
        transitions from: :asking, to: :asking

        after do
          decrement_index!
          save
        end
      end

      event :undo do
        transitions from: :asked, to: :asking_last

        after do
          save
        end
      end

      event :finish do
        transitions from: :asking_last, to: :asked

        after do
          save
        end
      end

      event :submit do
        transitions from: :asked, to: :marked

        after do
          save
        end
      end
    end

    def initialize(name: nil, questions: nil, **rest)
      super

      self.name = name
      self.questions = questions || []
      self.total = self.questions.size
    end

    def initialize_challenge!
      self.index = 0
      self.answers = []
    end

    def fowardable?
      asking_first? || asking?
    end

    def increment_index!
      self.index += 1
    end

    def decrement_index!
      self.index -= 1
    end

    def first?
      index == 0
    end

    def prev_index_first?
      index - 1 == 0
    end

    def next_index_last?
      index + 2 == total
    end

    def last?
      index + 1 == total
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