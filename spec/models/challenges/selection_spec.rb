require 'rails_helper'

RSpec.describe Challenge::Selection, type: :model do
  let(:klass) { Challenge::Selection }
  let(:model) { klass.new(name: 'dummy', questions: [1, 3, 2, 4]) }
  let(:restored) { klass.find(model.id) }

  it { expect(model).to be_a(klass) }

  describe 'game' do
    before :each do
      model.start!
    end

    context 'when first' do
      before :each do
        model.answer_and_forward!(1)
      end

      it { expect(restored.answers).to eq([1]) }
      it { expect(restored.question).to eq(3) }
      it { expect(restored.index).to eq(1) }
      it { expect(restored.asking?).to be_truthy }
    end

    context 'when second' do
      before :each do
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
        it { expect(restored.asking_first?).to be_truthy }

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
        model.answer_and_forward!(1)
        model.answer_and_forward!(2)
        model.answer_and_forward!(3)
      end

      it { expect(restored.answers).to eq([1, 2, 3]) }
      it { expect(restored.question).to eq(4) }
      it { expect(restored.index).to eq(3) }
      it { expect(restored.asking_last?).to be_truthy }
    end

    context 'when last' do
      before :each do
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
        it { expect(restored.asking_last?).to be_truthy }
      end
    end
  end

  describe 'state machine transition' do
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

    context 'when ready' do
      before :each do
        model.save
      end

      it { expect(restored.ready?).to be_truthy }

      it { expect(restored.start!).to be_truthy }

      it { expect { restored.forward! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.backward! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.undo! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.finish! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.submit! }.to raise_error(AASM::InvalidTransition) }

      it do
        model.start!
        expect(restored.asking_first?).to be_truthy
      end
    end

    context 'when asking_first' do
      before :each do
        model.start!
      end

      it { expect(restored.asking_first?).to be_truthy }

      it { expect(restored.forward!).to be_truthy }

      it { expect { restored.start! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.backward! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.undo! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.finish! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.submit! }.to raise_error(AASM::InvalidTransition) }

      it do
        model.forward!
        expect(restored.asking?).to be_truthy
      end
    end

    context 'when asking' do
      before :each do
        model.start!
        model.forward!
      end

      it { expect(restored.asking?).to be_truthy }

      it { expect(restored.forward!).to be_truthy }
      it { expect(restored.backward!).to be_truthy }

      it { expect { restored.start! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.undo! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.finish! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.submit! }.to raise_error(AASM::InvalidTransition) }

      it do
        model.forward!
        expect(restored.asking?).to be_truthy
      end

      it do
        model.forward!
        model.forward!
        expect(restored.asking_last?).to be_truthy
      end

      it do
        model.backward!
        expect(restored.asking_first?).to be_truthy
      end
    end

    context 'when asking_last' do
      before :each do
        model.start!
        model.forward!
        model.forward!
        model.forward!
      end

      it { expect(restored.asking_last?).to be_truthy }

      it { expect(restored.backward!).to be_truthy }
      it { expect(restored.finish!).to be_truthy }

      it { expect { restored.start! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.forward! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.undo! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.submit! }.to raise_error(AASM::InvalidTransition) }

      it do
        model.backward!
        expect(restored.asking?).to be_truthy
      end

      it do
        model.finish!
        expect(restored.asked?).to be_truthy
      end
    end

    context 'when asked' do
      before :each do
        model.start!
        model.forward!
        model.forward!
        model.forward!
        model.finish!
      end

      it { expect(restored.asked?).to be_truthy }

      it { expect(restored.undo!).to be_truthy }
      it { expect(restored.submit!).to be_truthy }

      it { expect { restored.start! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.forward! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.backward! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.finish! }.to raise_error(AASM::InvalidTransition) }

      it do
        model.undo!
        expect(restored.asking_last?).to be_truthy
      end

      it do
        model.submit!
        expect(restored.marked?).to be_truthy
      end
    end

    context 'when asked' do
      before :each do
        model.start!
        model.forward!
        model.forward!
        model.forward!
        model.finish!
        model.submit!
      end

      it { expect(restored.marked?).to be_truthy }

      it { expect { restored.start! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.forward! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.backward! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.finish! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.undo! }.to raise_error(AASM::InvalidTransition) }
      it { expect { restored.submit! }.to raise_error(AASM::InvalidTransition) }
    end
  end

  describe 'accessor' do
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