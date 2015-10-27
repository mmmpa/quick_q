require 'rails_helper'

RSpec.describe ConvertMdTo, type: :model do
  before :all do
    @md = File.read("#{Rails.root}/spec/fixtures/questions_md.md")
  end

  after :all do
    Qa::Question.destroy_all
  end

  let(:md) { @md }

  it do
    expect {
      ConvertMdTo.questions(md).execute
    }.to change(Qa::Question, :count).by(2)
  end

  it do
    ConvertMdTo.questions(md).execute

    expect {
      ConvertMdTo.questions(md).execute
    }.to change(Qa::Question, :count).by(0)
  end

end
