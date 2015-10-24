require 'rails_helper'

RSpec.describe Challenge::Selection, type: :model do
  let(:klass) { Challenge::Selection }
  let(:model) { klass.new }
  let(:restored) { klass.find(model.id) }

  it { expect(model).to be_a(klass) }

  describe 'state machine' do
    it { expect(model.ready?).to be_truthy }

    it do
      model.start!
      expect(model.asking_first?).to be_truthy
    end

    it do
      model.start!
      read_model = klass.find(model.id)
      expect(read_model.asking_first?).to be_truthy
    end
  end

  describe 'accessor' do
    context 'with index' do
      before :each do
        model.index
        model.index = 1
      end

      it { expect(model.index).to eq(1) }
      it { expect(restored.index).to eq(1) }
    end

    context 'with total' do
      before :each do
        model.total
        model.total = 1
      end

      it { expect(model.total).to eq(1) }
      it { expect(restored.total).to eq(1) }
    end

    context 'with answers' do
      before :each do
        model.answers
        model.answers = [1, 2, 'a', [1, true]]
      end

      it { expect(model.answers).to eq([1, 2, 'a', [1, true]]) }
      it { expect(restored.answers).to eq([1, 2, 'a', [1, true]]) }
    end

    context 'with answer' do
      before :each do
        model.answers
        model.index = 1
        model.answers = [1, 2, 'a', [1, true]]
        model.answer = 22
      end

      it { expect(model.answer).to eq(22) }
      it { expect(restored.answer).to eq(22) }
      it { expect(model.answers).to eq([1, 22, 'a', [1, true]]) }
      it { expect(restored.answers).to eq([1, 22, 'a', [1, true]]) }
    end

    context 'with name' do
      before :each do
        model.name
        model.name = 'name'
      end

      it { expect(model.name).to eq('name') }
      it { expect(restored.name).to eq('name') }
    end

    context 'with questions' do
      before :each do
        model.questions
        model.index = 1
        model.questions = [1, 2, 'a', [1, true]]
      end

      it { expect(model.question).to eq(2) }
      it { expect(restored.question).to eq(2) }
      it { expect(model.questions).to eq([1, 2, 'a', [1, true]]) }
      it { expect(restored.questions).to eq([1, 2, 'a', [1, true]]) }
    end
  end
end