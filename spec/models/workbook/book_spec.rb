require 'rails_helper'

RSpec.describe Workbook::Book, type: :model do
  let(:klass) { Workbook::Book }
  let(:model) { build(:workbook_book, :valid) }

  describe 'validation' do
    context 'when eval_type is blank' do
      before :each do
        model.eval_type = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when eval_type is input' do
      it_behaves_like 'valid model'
    end

    context 'when name is blank' do
      before :each do
        model.name = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when name is input' do
      it_behaves_like 'valid model'
    end

    context 'when passing is blank' do
      before :each do
        model.passing = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when passing is input' do
      it_behaves_like 'valid model'
    end
  end
end
