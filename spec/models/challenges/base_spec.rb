require 'rails_helper'

RSpec.describe Challenge::Base, type: :model do
  let(:klass) { Challenge::Base }
  let(:model) { klass.new }

  it { expect(model).to be_a(klass) }

  describe 'persistence' do
    context 'when initialized' do
      it { expect(klass.new.id).to be_truthy }
      it { expect(klass.new.id).not_to eq(klass.new.id) }
    end

    context 'when restore' do
      let!(:model1) { klass.new }
      let!(:model2) { klass.new }

      before :each do
        model1.aasm_state = 'test'
        model1.save
        model2.save
      end

      it do
        read_model = klass.find(model1.id)
        expect(read_model.aasm_state).to eq('test')
      end

      it do
        read_model = klass.find(model2.id)
        expect(read_model.aasm_state).not_to eq('test')
      end
    end
  end
end