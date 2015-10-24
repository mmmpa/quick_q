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
        model1.answers << 1
      end

      it do
        read_model = klass.find(model1.id)
        expect(read_model.answers).not_to be_nil
      end

      it do
        read_model = klass.find(model2.id)
        expect(read_model.answers).to be_blank
      end
    end
  end
end