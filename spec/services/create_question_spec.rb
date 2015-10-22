require 'rails_helper'

RSpec.describe CreateQuestion, type: :model do
  describe 'from json' do
    before :all do
      @json = File.read("#{Rails.root}/spec/fixtures/rinsho_1_10.json")
    end

    it do
      expect{
        CreateQuestion.from(json: @json)
      }.to change(Qa::Question, :count).by(10)
    end
  end
end

