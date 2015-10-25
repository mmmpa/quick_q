require 'rails_helper'

RSpec.describe Challenge::Selection, type: :model do
  let(:klass) { Challenge::Selection }
  let(:model) { klass.new }
  let(:restored) { klass.find(model.id) }

  it { expect(model).to be_a(klass) }

  def dummy_starter
    {name: 'dummy', questions: [1, 3, 2, 4], selection_id: 1}
  end

  describe 'game' do
    context 'when ready' do
      it { expect { restored.start! }.to raise_error(Challenge::Selection::MissingRequiredParameters) }
    end

    context 'when asking' do
      before :each do
        model.start_with!(dummy_starter)
        model.answer_and_forward!(1)
      end

      it { expect(restored.answers).to eq([1]) }
      it { expect(restored.question).to eq(3) }
      it { expect(restored.index).to eq(1) }
      it { expect(restored.asking?).to be_truthy }

    end

    context 'when not yet answered all' do
      before :each do
        model.start_with!(dummy_starter)
        model.answer_and_forward!(1)
      end

      it { expect{restored.finish!}.to raise_error(Challenge::Selection::NotYetAnsweredAll) }
    end

    context 'when second' do
      before :each do
        model.start_with!(dummy_starter)
        model.answer_and_forward!(1)
      end

      context 'then forward' do
        before :each do
          model.answer_and_forward!(2)
        end

        it { expect(restored.answers).to eq([1, 2]) }
        it { expect(restored.question).to eq(2) }
        it { expect(restored.index).to eq(2) }
        it { expect(restored.asking?).to be_truthy }
      end

      context 'then backward' do
        before :each do
          model.backward!
        end

        it { expect(restored.answers).to eq([1]) }
        it { expect(restored.question).to eq(1) }
        it { expect(restored.index).to eq(0) }
        it { expect(restored.asking?).to be_truthy }

        context 'then forward' do
          before :each do
            model.answer_and_forward!(50)
          end

          it { expect(restored.answers).to eq([50]) }
          it { expect(restored.question).to eq(3) }
          it { expect(restored.index).to eq(1) }
          it { expect(restored.asking?).to be_truthy }
        end
      end
    end

    context 'when third' do
      before :each do
        model.start_with!(dummy_starter)
        model.answer_and_forward!(1)
        model.answer_and_forward!(2)
        model.answer_and_forward!(3)
      end

      it { expect(restored.answers).to eq([1, 2, 3]) }
      it { expect(restored.question).to eq(4) }
      it { expect(restored.index).to eq(3) }
      it { expect(restored.asking?).to be_truthy }
    end

    context 'when last' do
      before :each do
        model.start_with!(dummy_starter)
        model.answer_and_forward!(1)
        model.answer_and_forward!(2)
        model.answer_and_forward!(3)
        model.answer_and_forward!(4)
      end

      it { expect(restored.answers).to eq([1, 2, 3, 4]) }
      it { expect { restored.question }.to raise_error(Challenge::Selection::AllQuestionsAsked) }
      it { expect(restored.index).to eq(3) }
      it { expect(restored.asked?).to be_truthy }
    end

    context 'when asked' do
      before :each do
        model.start_with!(dummy_starter)
        model.answer_and_forward!(1)
        model.answer_and_forward!(2)
        model.answer_and_forward!(3)
        model.answer_and_forward!(4)
      end

      context 'then submit' do
        before :each do
          model.submit!
        end

        it { expect(restored.answers).to eq([1, 2, 3, 4]) }
        it { expect { restored.question }.to raise_error(Challenge::Selection::AllQuestionsAsked) }
        it { expect(restored.index).to eq(3) }
        it { expect(restored.marked?).to be_truthy }
      end

      context 'then undo' do
        before :each do
          model.undo!
        end

        it { expect(restored.answers).to eq([1, 2, 3, 4]) }
        it { expect(restored.question).to eq(4) }
        it { expect(restored.index).to eq(3) }
        it { expect(restored.asking?).to be_truthy }
      end
    end
  end

  describe 'state machine transition' do
    it { expect(model.ready?).to be_truthy }

    it do
      model.start_with!(dummy_starter)
      expect(model.asking?).to be_truthy
    end

    it do
      model.start_with!(dummy_starter)
      read_model = klass.find(model.id)
      expect(read_model.asking?).to be_truthy
    end

    context 'when ready' do
      before :each do
        model.save
      end

      it { expect(restored.ready?).to be_truthy }

      it { expect(restored.start_with!(dummy_starter)).to be_truthy }

      it { expect { restored.undo! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.finish! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.submit! }.to raise_error(AASM::InvalidTransition) }

      it do
        model.start_with!(dummy_starter)
        expect(restored.asking?).to be_truthy
      end
    end

    context 'when asking' do
      before :each do
        model.start_with!(dummy_starter)
      end

      it { expect(restored.asking?).to be_truthy }
      it { expect{restored.finish!}.to raise_error(Challenge::Selection::NotYetAnsweredAll) }

      it { expect { restored.start! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.undo! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.submit! }.to raise_error(AASM::InvalidTransition) }

      it do
        model.answers = [1, 2, 3, 4]
        model.finish!
        expect(restored.asked?).to be_truthy
      end
    end

    context 'when asked' do
      before :each do
        model.start_with!(dummy_starter)
        model.answers = [1, 2, 3, 4]
        model.finish!
      end

      it { expect(restored.asked?).to be_truthy }

      it { expect(restored.undo!).to be_truthy }
      it { expect(restored.submit!).to be_truthy }

      it { expect { restored.start! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.finish! }.to raise_error(AASM::InvalidTransition) }

      it do
        model.undo!
        expect(restored.asking?).to be_truthy
      end

      it do
        model.submit!
        expect(restored.marked?).to be_truthy
      end
    end

    context 'when asked' do
      before :each do
        model.start_with!(dummy_starter)
        model.answers = [1, 2, 3, 4]
        model.finish!
        model.submit!
      end

      it { expect(restored.marked?).to be_truthy }

      it { expect { restored.start! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.finish! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.undo! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.submit! }.to raise_error(AASM::InvalidTransition) }
    end
  end

  describe 'accessor' do
    before :each do
      model.start_with!(dummy_starter)
    end

    context 'with index' do
      before :each do
        model.index
        model.index = 1
        model.save
      end

      it { expect(model.index).to eq(1) }
      it { expect(restored.index).to eq(1) }
    end

    context 'with total' do
      before :each do
        model.total
        model.total = 1
        model.save
      end

      it { expect(model.total).to eq(1) }
      it { expect(restored.total).to eq(1) }
    end

    context 'with answers' do
      before :each do
        model.answers
        model.answers = [1, 2, 'a', [1, true]]
        model.save
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
        model.save
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
        model.save
      end

      it { expect(model.name).to eq('name') }
      it { expect(restored.name).to eq('name') }
    end

    context 'with questions' do
      before :each do
        model.questions
        model.index = 1
        model.questions = [1, 2, 'a', [1, true]]
        model.save
      end

      it { expect(model.question).to eq(2) }
      it { expect(restored.question).to eq(2) }
      it { expect(model.questions).to eq([1, 2, 'a', [1, true]]) }
      it { expect(restored.questions).to eq([1, 2, 'a', [1, true]]) }
    end
  end
end