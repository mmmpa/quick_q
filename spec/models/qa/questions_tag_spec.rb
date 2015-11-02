require 'rails_helper'

RSpec.describe Qa::QuestionsTag, type: :model do
  let(:klass) { Qa::QuestionsTag }
  let(:model) { build(:qa_questions_tag, :valid) }

  describe 'validation' do
    context 'when question is blank' do
      before :each do
        model.question = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when tag is blank' do
      before :each do
        model.tag = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when question and tag are already used' do
      before :each do
        new_pal = create(:qa_questions_tag, :valid)
        model.tag = new_pal.tag
        model.question = new_pal.question
      end

      it_behaves_like 'invalid model'
    end

    context 'when input' do
      it_behaves_like 'valid model'
    end
  end
end
