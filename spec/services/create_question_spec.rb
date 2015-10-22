require 'rails_helper'

RSpec.describe CreateQuestion, type: :model do
  describe 'from json' do
    context 'with valid json' do
      before :all do
        @json = File.read("#{Rails.root}/spec/fixtures/sample.json")
        Qa::Question.destroy_all
        CreateQuestion.from(json: @json)
      end

      after :all do
        Qa::Question.destroy_all
      end

      it { expect(Qa::Question.count).to eq(10) }
      it { expect(Qa::Explanation.count).to eq(3) }
      it { expect(Qa::AnswerOption.count).to eq(26) }
    end
    context 'with invalid json' do
      it do
        expect {
        CreateQuestion.from(json: <<-EOS)
          {
            "questions": [
              {
                "type": "not",
                "question": {
                  "text": "テキスト入力問題です。答えは「正答」。"
                },
                "explanation": "",
                "answer": "正答"
              }
            ]
          }
        EOS
        }.to raise_error(CreateQuestion::InvalidType)
      end

      it do
        expect {
          CreateQuestion.from(json: <<-EOS)
          {
            "questions": [
              {
                "type": "text",
                "question": {
                  "text": "テキスト入力問題です。答えは「正答」。"
                },
                "explanation": "",
                "answer": ""
              }
            ]
          }
          EOS
        }.to raise_error(CreateQuestion::CreationFailed)
      end
    end
  end
end

