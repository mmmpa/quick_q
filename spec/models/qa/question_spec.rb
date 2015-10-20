require 'rails_helper'

RSpec.describe Qa::Question, type: :model do
  let(:klass) { Qa::Question }
  let(:model) { build(:qa_question, :valid) }

  describe 'factory girl' do
    it { expect { create(:qa_question) }.to raise_error(ActiveRecord::RecordInvalid) }
    it { expect(create(:qa_question, :valid)).to be_a(klass) }
  end

  describe 'arrange method' do
    describe 'arrange for "boolean"' do
      context 'when arrange default' do
        before :each do
          model.arrange_for_boolean!(correct_answer: true)
        end

        it { expect(model.boolean?).to be_truthy }
        it { expect(model.correct_answers.size).to eq(1) }
        it { expect(model.answer_options.size).to eq(2) }
        it { expect(model.answer_options.pluck(:text)).to match_array(['o', 'x']) }
        it { expect(model.correct?(true)).to be_truthy }
        it { expect(model.correct?(false)).to be_falsey }
      end

      context 'when arrange other way' do
        before :all do
          @model = create(:qa_question, :valid)
          @model.free_text!
          @model.save

          @model.answer_options.create(attributes_for(:qa_answer_option, :valid))
          @model.correct_answers.create(
            attributes_for(
              :qa_correct_answer, :valid,
              answer_option: @model.answer_options.first
            ))

          @model.arrange_for_boolean!(correct_answer: true)
        end

        after :all do
          @model.destroy
        end

        let(:model) { @model }


        it { expect(model.boolean?).to be_truthy }
        it { expect(model.correct_answers.size).to eq(1) }
        it { expect(model.answer_options.size).to eq(2) }
        it { expect(model.answer_options.pluck(:text)).to match_array(['o', 'x']) }
        it { expect(model.correct?(true)).to be_truthy }
        it { expect(model.correct?(false)).to be_falsey }
      end
    end

    describe 'arrange for "free text"' do

      context 'when arrange default' do
        before :all do
          @model = create(:qa_question, :valid)

          @answer = SecureRandom.hex(4)
          @model.arrange_for_free_text!(correct_answer: @answer)
        end

        after :all do
          @model.destroy
        end

        let(:model) { @model }
        let(:answer) { @answer }

        it { expect(model.free_text?).to be_truthy }
        it { expect(model.correct_answers.size).to eq(1) }
        it { expect(model.answer_options.size).to eq(1) }
        it { expect(model.answer_options.pluck(:text)).to match_array([answer]) }
        it { expect(model.correct?(answer)).to be_truthy }
        it { expect(model.correct?(``)).to be_falsey }
        it { expect(model.correct?(`incorrect`)).to be_falsey }
      end

      context 'when arrange other way' do
        before :all do
          @model = create(:qa_question, :valid)

          @model.answer_options.create(attributes_for(:qa_answer_option, :valid))
          @model.correct_answers.create(
            attributes_for(
              :qa_correct_answer, :valid,
              answer_option: @model.answer_options.first
            ))

          @answer = SecureRandom.hex(4)
          @model.arrange_for_free_text!(correct_answer: @answer)
        end

        after :all do
          @model.destroy
        end

        let(:model) { @model }
        let(:answer) { @answer }

        it { expect(model.free_text?).to be_truthy }
        it { expect(model.correct_answers.size).to eq(1) }
        it { expect(model.answer_options.size).to eq(1) }
        it { expect(model.answer_options.pluck(:text)).to match_array([answer]) }
        it { expect(model.correct?(answer)).to be_truthy }
        it { expect(model.correct?('')).to be_falsey }
        it { expect(model.correct?('incorrect')).to be_falsey }
      end
    end
  end

  describe 'answer the question' do
    context 'with "free text" way' do
      let(:answer) { SecureRandom.hex(4) }

      before :each do
        model.arrange_for_free_text!(correct_answer: answer)
      end


      context 'when correct answer' do
        it do
          expect(model.correct?(answer)).to be_truthy
        end
      end

      context 'when incorrect answer' do
        it do
          expect(model.correct?('')).to be_falsey
        end

        it do
          expect(model.correct?('incorrect')).to be_falsey
        end
      end
    end

    #
    # フリーテキスト以外は選択肢が必要
    #

    before :all do
      @model = create(:qa_question, :valid)
      10.times do
        @model.answer_options.create(attributes_for(:qa_answer_option, :valid))
      end
    end

    after :all do
      @model.destroy
    end

    let(:model) { @model }

    before :each do
      model.correct_answers.destroy_all
    end

    context 'with "choice", "boolean" way' do
      before :each do
        model.choice!
        model.save

        sampler = model.answer_options.sampler
        model.correct_answers.create(
          attributes_for(
            :qa_correct_answer, :valid,
            answer_option: sampler.pick
          ))
      end

      context 'when correct answer' do
        it do
          ids = model.correct_answers.pluck(:answer_option_id)
          expect(model.correct?(ids)).to be_truthy
        end
      end

      context 'when incorrect answer' do
        it do
          ids = []
          expect(model.correct?(ids)).to be_falsey
        end

        it do
          ids = [-1]
          expect(model.correct?(ids)).to be_falsey
        end

        it do
          ids = model.correct_answers.pluck(:answer_option_id)
          ids.push(1)
          expect(model.correct?(ids)).to be_falsey
        end

        it do
          ids = model.correct_answers.pluck(:answer_option_id)
          ids.reverse!
          expect(model.correct?(ids)).to be_truthy
        end
      end
    end

    context 'with "choices" way' do
      before :each do
        model.choices!
        model.save

        sampler = model.answer_options.sampler
        (rand(2)+2).times do
          model.correct_answers.create(
            attributes_for(
              :qa_correct_answer, :valid,
              answer_option: sampler.pick
            ))
        end
      end

      context 'when correct answer' do
        it do
          ids = model.correct_answers.pluck(:answer_option_id)
          expect(model.correct?(ids)).to be_truthy
        end
      end

      context 'when incorrect answer' do
        it do
          ids = model.correct_answers.pluck(:answer_option_id)
          ids.shift
          expect(model.correct?(ids)).to be_falsey
        end

        it do
          ids = []
          expect(model.correct?(ids)).to be_falsey
        end

        it do
          ids = model.correct_answers.pluck(:answer_option_id)
          ids.push(1)
          expect(model.correct?(ids)).to be_falsey
        end

        it do
          ids = model.correct_answers.pluck(:answer_option_id)
          ids.reverse!
          expect(model.correct?(ids)).to be_truthy
        end
      end
    end

    context 'with "in_order" way' do
      before :each do
        model.in_order!
        model.save

        sampler = model.answer_options.sampler
        (rand(2)+2).times do
          model.correct_answers.create(
            attributes_for(
              :qa_correct_answer, :valid,
              answer_option: sampler.pick
            ))
        end
      end

      context 'when correct answer' do
        it do
          ids = model.correct_answers.pluck(:answer_option_id)
          expect(model.correct?(ids)).to be_truthy
        end
      end

      context 'when incorrect answer' do
        it do
          ids = model.correct_answers.pluck(:answer_option_id)
          ids.shift
          expect(model.correct?(ids)).to be_falsey
        end

        it do
          ids = []
          expect(model.correct?(ids)).to be_falsey
        end

        it do
          ids = model.correct_answers.pluck(:answer_option_id)
          ids.push(1)
          expect(model.correct?(ids)).to be_falsey
        end

        it do
          ids = model.correct_answers.pluck(:answer_option_id)
          ids.reverse!
          expect(model.correct?(ids)).to be_falsey
        end
      end
    end
  end

  describe 'validation' do
    context 'when text is blank' do
      before :each do
        model.text = nil
      end

      it { expect(model.valid?).to be_falsey }
      it { expect(model.save).to be_falsey }
      it { expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'when way is blank' do
      before :each do
        model.way = nil
      end

      it { expect(model.valid?).to be_falsey }
      it { expect(model.save).to be_falsey }
      it { expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'when all are input' do
      it { expect(model.valid?).to be_truthy }
      it { expect(model.save).to be_truthy }
      it { expect(model.save!).to be_truthy }
    end

    context 'when correct answers detected' do
      before :each do
        model.save
        5.times do
          model.answer_options.create(attributes_for(:qa_answer_option, :valid))
        end
      end

      context 'when not included answer options' do
        before :each do
          model.correct_answers.create(attributes_for(:qa_correct_answer, :valid))
        end

        it { expect(model.valid?).to be_falsey }
        it { expect(model.save).to be_falsey }
        it { expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid) }
      end

      context 'when included answer options' do
        before :each do
          model.correct_answers.create(
            attributes_for(
              :qa_correct_answer, :valid,
              answer_option: model.answer_options.sample
            ))
        end
        it { expect(model.valid?).to be_truthy }
        it { expect(model.save).to be_truthy }
        it { expect(model.save!).to be_truthy }
      end
    end
  end
end
