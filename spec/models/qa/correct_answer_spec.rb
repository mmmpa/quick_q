require 'rails_helper'

RSpec.describe Qa::CorrectAnswer, type: :model do
  let(:klass) { Qa::CorrectAnswer }
  let(:model) { build(:qa_correct_answer, :valid) }

  describe 'validation' do
    context 'when answer option is blank' do
      before :each do
        model.answer_option = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when question is blank' do
      before :each do
        model.question = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when all are input' do
      it_behaves_like 'valid model'
    end
  end
end
