require 'rails_helper'

RSpec.describe Qa::AnswerOption, type: :model do
  let(:klass) { Qa::AnswerOption }
  let(:model) { build(:qa_answer_option, :valid) }

  describe 'validation' do
    context 'when text is blank' do
      before :each do
        model.text = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when question is blank' do
      before :each do
        model.question = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when text is input' do
      it_behaves_like 'valid model'
    end
  end
end
