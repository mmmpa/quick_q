require 'rails_helper'

RSpec.describe Qa::CorrectAnswer, type: :model do
  let(:klass) { Qa::CorrectAnswer }
  let(:model) { build(:qa_correct_answer, :valid) }

  describe 'validation' do
    context 'when answer option is blank' do
      before :each do
        model.answer_option = nil
      end

      it { expect(model.valid?).to be_falsey }
      it { expect(model.save).to be_falsey }
      it { expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'when question is blank' do
      before :each do
        model.question = nil
      end

      it { expect(model.valid?).to be_falsey }
      it { expect(model.save).to be_falsey }
      it { expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'when all are input' do
      it { expect(model.valid?).to be_truthy }
      it { expect(model.save).to be_truthy }
      it { expect(model.save!).to be_truthy }
    end
  end
end
