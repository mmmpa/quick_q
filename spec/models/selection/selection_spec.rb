require 'rails_helper'

RSpec.describe Selection::Selection, type: :model do
  let(:klass) { Selection::Selection }
  let(:model) { build(:selection_selection, :valid) }

  describe 'validation' do
    context 'when name is blank' do
      before :each do
        model.name = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when choice_type is blank' do
      before :each do
        model.choice_type = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when choice type is not manual' do
      before :each do
        model.choice_type = Selection::Selection.choice_types[:random]
        model.questions << create(:qa_question, :valid)
      end

      it_behaves_like 'invalid model'
    end

    context 'when input' do
      it_behaves_like 'valid model'
    end
  end
end
