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
      context 'then question added' do
        before :each do
          model.choice_type = Selection::Selection.choice_types[:random]
          model.total = 1
          model.questions << create(:qa_question, :valid)
        end

        it_behaves_like 'invalid model'
      end

      context 'then total smaller than 1' do
        before :each do
          model.choice_type = Selection::Selection.choice_types[:random]
          model.total = 0
        end

        it_behaves_like 'invalid model'
      end

      context 'then total is blank' do
        before :each do
          model.choice_type = Selection::Selection.choice_types[:random]
        end

        it_behaves_like 'invalid model'
      end

      context 'then total equal or larger 1' do
        before :each do
          model.choice_type = Selection::Selection.choice_types[:random]
          model.total = 1
        end

        it_behaves_like 'valid model'
      end
    end

    context 'when input' do
      it_behaves_like 'valid model'
    end
  end
end
