require 'rails_helper'

RSpec.describe Workbook::Question, type: :model do
  let(:klass) { Workbook::Question }
  let(:model) { build(:workbook_question, :valid) }

  describe 'validation' do
    context 'when score is blank' do
      before :each do
        model.score = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when score is input' do
      it_behaves_like 'valid model'
    end

    context 'when book is blank' do
      before :each do
        model.book = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when book is input' do
      it_behaves_like 'valid model'
    end

    context 'when question is blank' do
      before :each do
        model.question = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when question is input' do
      it_behaves_like 'valid model'
    end

    context 'when book and question are already used' do
      before :each do
        old = create(:workbook_question, :valid)
        model.question = old.question
        model.book = old.book
      end

      it_behaves_like 'invalid model'
    end
  end
end
