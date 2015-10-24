module Challenge
  #
  # 問題への挑戦を管理するモデル
  # redis-objectsを使用するので、idが必要。
  # guestではanonymous_idを仕様、アカウントではuser_idを使用
  #
  # = Attributes
  #
  # - aasm_state ステートマシンのステート永続化。
  # - game_state チャレンジの種類、日時などを保持
  # - challenge_state チャレンジ中の結果などを保持。
  #
  # hash_keyに関してはサブクラスにより内容がちがう。

  class Base
    include AASM
    include Redis::Objects

    value :aasm_state
    hash_key :game_state
    hash_key :challenge_state
    value :test
    value :test1
    value :test2

    # ステートマシンはこのクラスを継承したサブクラスで設定する。

    class << self
      def find(id)
        new(id: id)
      end

      def account_id(id)
        "user_id_#{id}"
      end

      def generate_anonymous_id!
        "aid_#{anonymous_id_generator.increment}"
      end

      private

      def anonymous_id_generator
        @stored_anonymous_id_generator ||= Redis::Counter.new('anonymous_id')
      end
    end

    def initialize(options = {})
      @id = detect_id(options)
    end

    def initialize_challenge!
      challenge_state.clear
    end

    def sweep!
      game_state.clear
      challenge_state.clear
    end

    ### required

    # for redis persistence
    def id
      @id
    end

    # for aasm persistence
    def aasm_write_state(state)
      self.aasm_state = state
    end

    # for aasm persistence
    def aasm_read_state
      aasm_state.value.try(:to_sym) || super
    end

    private

    def detect_id(options = {})
      case
        when options[:id].present?
          options[:id]
        when options[:user].present?
          self.class.account_id(options[:user].id)
        else
          self.class.generate_anonymous_id!
      end
    end
  end
end