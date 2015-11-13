require 'rails_helper'

class DummyUser
  attr_accessor :id

  def initialize(id)
    self.id = id
  end
end

RSpec.describe Challenge::Base, type: :model do
  let(:klass) { Challenge::Base }
  let(:model) { klass.new }

  it { expect(model).to be_a(klass) }

  describe 'generate id' do
    it do
      a = klass.generate_anonymous_id!
      b = klass.generate_anonymous_id!
      expect(a).not_to eq(b)
    end

    it { expect(klass.account_id('new_id')).to include('new_id') }
  end

  describe 'persistence' do
    context 'when initialized' do
      it { expect(klass.new.id).to be_truthy }
      it { expect(klass.new.id).not_to eq(klass.new.id) }

      context 'with model has id' do
        it do
          user = DummyUser.new('id')
          new_challenge = klass.new(user: user)
          expect(new_challenge.id).to eq(klass.account_id('id'))
        end
      end
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