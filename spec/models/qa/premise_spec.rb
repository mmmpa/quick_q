require 'rails_helper'

RSpec.describe Qa::Premise, type: :model do
  let(:klass) { Qa::Explanation }
  let(:model) { build(:qa_premise, :valid) }


  describe 'validation' do
    context 'when name is already used' do
      before :each do
        create(:qa_premise, :valid, name: 'a')
        model.name = 'a'
      end

      it_behaves_like 'invalid model'
    end

    context 'when text is blank' do
      before :each do
        model.text = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when text is input' do
      it_behaves_like 'valid model'
    end
  end

  describe 'assciation' do
    context 'with question' do
      let(:question) { create(:qa_question, :valid) }

      it do
        model.save!
        model.questions << question
        expect(model.questions(true).size).to eq(1)
      end
    end
  end
end
