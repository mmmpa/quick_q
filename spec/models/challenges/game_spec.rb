require 'rails_helper'

RSpec.describe Challenge::Game, type: :model do
  let(:klass) { Challenge::Game }
  let(:model) { klass.new }

  it { expect(model).to be_a(klass) }

  describe 'state machine' do
    it { expect(model.ready?).to be_truthy }

    it do
      model.start!
      expect(model.asking_first?).to be_truthy
    end

    it do
      model.start!
      pp model.aasm_state
    end
  end

  describe 'wheel state machine' do
    context 'when is asking' do

    end
  end
end