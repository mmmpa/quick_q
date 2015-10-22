require 'rails_helper'

RSpec.describe CreateQuestion, type: :model do
  describe 'from csv' do
    context 'with valid csv' do
      context 'for text' do
        before :all do
          @csv = File.read("#{Rails.root}/spec/fixtures/text.csv")
          Qa::Question.destroy_all
          CreateQuestion.from(csv: @csv, way: :free_text)
        end

        after :all do
          Qa::Question.destroy_all
        end

        it { expect(Qa::Question.count).to eq(5) }
        it { expect(Qa::Explanation.count).to eq(2) }
        it { expect(Qa::AnswerOption.count).to eq(5) }
      end

      context 'for ox' do
        before :all do
          @csv = File.read("#{Rails.root}/spec/fixtures/ox.csv")
          Qa::Question.destroy_all
          CreateQuestion.from(csv: @csv, way: :ox)
        end

        after :all do
          Qa::Question.destroy_all
        end

        it { expect(Qa::Question.count).to eq(5) }
        it { expect(Qa::Explanation.count).to eq(2) }
        it { expect(Qa::AnswerOption.count).to eq(10) }
      end

      context 'for single' do
        before :all do
          @csv = File.read("#{Rails.root}/spec/fixtures/single.csv")
          Qa::Question.destroy_all
          CreateQuestion.from(csv: @csv, way: :single_choice)
        end

        after :all do
          Qa::Question.destroy_all
        end

        it { expect(Qa::Question.count).to eq(5) }
        it { expect(Qa::Explanation.count).to eq(2) }
        it { expect(Qa::AnswerOption.count).to eq(10) }
      end

      context 'for multiple' do
        before :all do
          @csv = File.read("#{Rails.root}/spec/fixtures/multiple.csv")
          Qa::Question.destroy_all
          CreateQuestion.from(csv: @csv, way: :multiple_choices)
        end

        after :all do
          Qa::Question.destroy_all
        end

        it { expect(Qa::Question.count).to eq(5) }
        it { expect(Qa::Explanation.count).to eq(2) }
        it { expect(Qa::AnswerOption.count).to eq(10) }
      end

      context 'for in order' do
        before :all do
          @csv = File.read("#{Rails.root}/spec/fixtures/order.csv")
          Qa::Question.destroy_all
          CreateQuestion.from(csv: @csv, way: :in_order)
        end

        after :all do
          Qa::Question.destroy_all
        end

        it { expect(Qa::Question.count).to eq(5) }
        it { expect(Qa::Explanation.count).to eq(2) }
        it { expect(Qa::AnswerOption.count).to eq(10) }
      end
    end
  end

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
