require 'rails_helper'

RSpec.describe Challenge::Base, type: :model do
  let(:klass) { Challenge::Base }
  let(:model) { klass.new }

  it { expect(model).to be_a(klass) }

  describe 'persistence' do
    context 'when initialized' do
      it { expect(klass.new.id).to be_truthy }
      it { expect(klass.new.id).not_to eq(klass.new.id) }
    end

    context 'when restore' do
      let!(:model1) { klass.new }
      let!(:model2) { klass.new }

      before :each do
        model1.game_state[:mode] = 'test'
      end

      it do
        read_model = klass.find(model1.id)
        expect(read_model.game_state[:mode]).to eq('test')
      end

      it do
        read_model = klass.find(model2.id)
        expect(read_model.game_state[:mode]).not_to eq('test')
      end
    end
  end

  describe 'sweep' do
    let(:restored) { klass.find(model.id) }

    before :each do
      model.game_state[:mode] = 'game'
      model.challenge_state[:mode] = 'challenge'
    end

    context 'before sweep' do
      it { expect(model.game_state[:mode]).to eq('game') }
      it { expect(model.challenge_state[:mode]).to eq('challenge') }
      it { expect(restored.game_state[:mode]).to eq('game') }
      it { expect(restored.challenge_state[:mode]).to eq('challenge') }
    end

    context 'after sweep' do
      before :each do
        model.sweep!
      end

      it { expect(model.game_state[:mode]).to be_nil }
      it { expect(model.challenge_state[:mode]).to be_nil }
      it { expect(restored.game_state[:mode]).to be_nil }
      it { expect(restored.challenge_state[:mode]).to be_nil }
    end
  end
end