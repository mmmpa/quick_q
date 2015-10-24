require 'rails_helper'

RSpec.describe Challenge::Selection, type: :model do
  let(:klass) { Challenge::Selection }
  let(:model) { klass.new }

  it { expect(model).to be_a(klass) }

  describe 'state machine' do
    it { expect(model.ready?).to be_truthy }

    it do
      model.start!
      expect(model.asking_first?).to be_truthy
    end

    it do
      model.start!
      read_model = klass.find(model.id)
      expect(read_model.asking_first?).to be_truthy
    end
  end
end