require 'rails_helper'

RSpec.describe Qa::Tag, type: :model do
  let(:klass) { Qa::Tag }
  let(:model) { build(:qa_tag, :valid) }


  describe 'validation' do
    context 'when name is already used' do
      before :each do
        create(:qa_tag, :valid, name: 'a')
        model.name = 'a'
      end

      it_behaves_like 'invalid model'
    end

    context 'when display is already used' do
      before :each do
        create(:qa_tag, :valid, display: 'a')
        model.display = 'a'
      end

      it_behaves_like 'invalid model'
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

    context 'when display is blank' do
      before :each do
        model.display = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when display is input' do
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
