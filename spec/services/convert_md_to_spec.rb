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
    ConvertMdTo.questions(md).execute
  end
end

