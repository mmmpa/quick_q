require 'rails_helper'

RSpec.describe Qa::Pal, type: :model do
  let(:klass) { Qa::Pal }
  let(:model) { build(:qa_pal, :valid) }

  describe 'validation' do
    context 'when question is blank' do
      before :each do
        model.question = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when premise is blank' do
      before :each do
        model.premise = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when question is already used' do
      before :each do
        new_pal = create(:qa_pal, :valid)
        model.question = new_pal.question
      end

      it_behaves_like 'invalid model'
    end

    context 'when premise is already used' do
      before :each do
        new_pal = create(:qa_pal, :valid)
        model.premise = new_pal.premise
      end

      it_behaves_like 'valid model'
    end

    context 'when input' do
      it_behaves_like 'valid model'
    end
  end
end
