require 'rails_helper'

RSpec.describe Qa::SourceLink, type: :model do
  let(:klass) { Qa::SourceLink }
  let(:model) { build(:qa_source_link, :valid) }


  describe 'validation' do
    context 'when name is already used' do
      before :each do
        create(:qa_source_link, :valid, name: 'a')
        model.name = 'a'
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

    context 'when display is blank' do
      before :each do
        model.display = nil
      end

      it_behaves_like 'invalid model'
    end

    context 'when url is input' do
      it_behaves_like 'valid model'
    end
  end
end
