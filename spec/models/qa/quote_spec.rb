require 'rails_helper'

RSpec.describe Qa::Quote, type: :model do
  let(:klass) { Qa::Quote }
  let(:model) { build(:qa_quote, :valid) }

  describe 'validation' do
    context 'when question is blank' do
      before :each do
        model.question = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when source_link is blank' do
      before :each do
        model.source_link = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when question is already used' do
      before :each do
        new_pal = create(:qa_quote, :valid)
        model.question = new_pal.question
      end

      it_behaves_like 'invalid model'
    end

    context 'when source_link is already used' do
      before :each do
        new_pal = create(:qa_quote, :valid)
        model.source_link = new_pal.source_link
      end

      it_behaves_like 'valid model'
    end

    context 'when input' do
      it_behaves_like 'valid model'
    end
  end
end
