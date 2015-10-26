require 'rails_helper'

RSpec.describe Selection::Question, type: :model do
  let(:klass) { Selection::Question }
  let(:model) { build(:selection_question, :valid) }

  describe 'validation' do
    context 'when question is blank' do
      before :each do
        model.question = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when premise is blank' do
      before :each do
        model.selection = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when question is already used' do
      before :each do
        new_table = create(:selection_question, :valid)
        model.question = new_table.question
      end

      it_behaves_like 'valid model'
    end

    context 'when selection is already used' do
      before :each do
        new_table = create(:selection_question, :valid)
        model.selection = new_table.selection
      end

      it_behaves_like 'valid model'
    end

    context 'when question and selection are already used' do
      before :each do
        new_table = create(:selection_question, :valid)
        model.question = new_table.question
        model.selection = new_table.selection
      end

      it_behaves_like 'invalid model'
    end

    context 'when input' do
      it_behaves_like 'valid model'
    end
  end
end
