module Challenge
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
  end
end