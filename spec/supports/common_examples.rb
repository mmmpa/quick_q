shared_examples 'invalid model' do
  it { expect(model.valid?).to be_falsey }
  it { expect(model.save).to be_falsey }
  it { expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid) }
end

shared_examples 'valid model' do
  it { expect(model.valid?).to be_truthy }
  it { expect(model.save).to be_truthy }
  it { expect(model.save!).to be_truthy }
end
