require 'rails_helper'

RSpec.describe Qa::SourceLink, type: :model do
  let(:klass) { Qa::SourceLink }
  let(:model) { build(:qa_source_link, :valid) }


  describe 'validation' do
    context 'when url is already used' do
      before :each do
        create(:qa_source_link, :valid, url: 'a')
        model.url = 'a'
      end

      it_behaves_like 'invalid model'
    end

    context 'when url is blank' do
      before :each do
        model.url = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when url is input' do
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
  end

  describe 'assciation' do
    context 'with question' do
      let(:question) { create(:qa_question, :valid) }

      it do
        model.save!
        model.questions << question
        expect(model.questions(true).size).to eq(1)
      end

      it do
        model.save!
        model.questions << question
        expect { model.questions << question }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
