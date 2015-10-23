module Challenge
  #
  # 問題への挑戦を管理するモデル
  # redis-objectsを使用するので、idが必要。
  # guestではanonymous_idを仕様、アカウントではuser_idを使用

  class Game
    include AASM
    include Redis::Objects

    #
    # ステートマシンの切りかえに使う
    #
    WHEEL = :wheel
    SELECTION = :selection
    WORKBOOK = :selection

    value :mode
    value :aasm_state
    list :question_ids
    list :answers

    aasm do
      state :ready, initial: true
      state :asking_first
      state :asking
      state :asking_last
      state :answered
      state :marked
      state :finished


      event :start do
        transitions from: :ready, to: :asking_first
      end

      event :challenge do
        before do
          # indexを一つすすめる
          p self
        end
        transitions from: :asking_first, to: :asking, guard: :not_first?
        transitions from: :asking, to: :asking, guard: :not_last?
        transitions from: :asking, to: :asking_last, guard: :last?
      end

      event :undo do
        # indexを一つもどす
        transitions from: :answered, to: :asking_last
        transitions from: :asking_last, to: :asking
        transitions from: :asking, to: :asking
        transitions from: :asking, to: :asking_first
      end

      event :finish do
        transitions from: :asking_last, to: :answered
      end

      event :submit do
        transitions from: :answered, to: :marked
      end
    end

    class << self
      def find(id)
        new(id: id)
      end

      def mode(mode_id)
        MODE[mode_id]
      end

      def account_id(id)
        "user_id_#{id}"
      end

      def generate_anonymous_id!
        "aid_#{anonymous_id_generator.increment}"
      end

      private

      MODE = {
        selection: :selection,
        workbook: :workbook,
        wheel: :wheel
      }

      def anonymous_id_generator
        @stored_anonymous_id_generator ||= Redis::Counter.new('anonymous_id')
      end
    end

    def initialize(options={})
      @id = detect_id(options)
    end

    #
    # redis-objects required
    #
    def id
      @id
    end

    def aasm_write_state(state)
      self.aasm_state = state
    end

    def aasm_read_state
      aasm_state.try(:to_sym) || super
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

    def workbook?
      mode.to_s.to_sym == Game::WORKBOOK
    end

    def selection?
      mode.to_s.to_sym == Game::SELECTION
    end

    def wheel?
      mode.to_s.to_sym == Game::WHEEL
    end

    private


    def detect_id(options={})
      case
        when options[:id].present?
          options[:id]
        when options[:user].present?
          Game.account_id(options[:user].id)
        else
          Game.generate_anonymous_id!
      end
    end
  end
end