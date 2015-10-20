require 'rails_helper'

RSpec.describe Qa::Question, type: :model do
  let(:klass) { Qa::Question }
  let(:model) { build(:qa_question, :valid) }

  describe 'factory girl' do
    it { expect { create(:qa_question) }.to raise_error(ActiveRecord::RecordInvalid) }
    it { expect(create(:qa_question, :valid)).to be_a(klass) }
  end

  #
  # shared_examples
  #

  shared_examples 'boolean way' do
    it { expect(model.boolean?).to be_truthy }
    it { expect(model.correct_answers.size).to eq(1) }
    it { expect(model.answer_options.size).to eq(2) }
    it { expect(model.answer_options.pluck(:text)).to match_array(['o', 'x']) }

    context 'with correct?' do
      it { expect(model.correct?(true)).to be_truthy }
      it { expect(model.correct?(false)).to be_falsey }
    end
  end

  shared_examples 'free text way' do
    it { expect(model.free_text?).to be_truthy }
    it { expect(model.correct_answers.size).to eq(1) }
    it { expect(model.answer_options.size).to eq(1) }
    it { expect(model.answer_options.pluck(:text)).to match_array([answer]) }

    context 'with correct?' do
      it { expect(model.correct?(answer)).to be_truthy }
      it { expect(model.correct?('')).to be_falsey }
      it { expect(model.correct?('')).to be_falsey }
    end
  end

  shared_examples 'choice way' do
    context 'with correct?' do
      it do
        ids = model.correct_answers.pluck(:answer_option_id)
        expect(model.correct?(ids)).to be_truthy
      end

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

  shared_examples 'choices way' do
    context 'with correct?' do
      it do
        ids = model.correct_answers.pluck(:answer_option_id)
        expect(model.correct?(ids)).to be_truthy
      end

      it do
        ids = model.correct_answers.pluck(:answer_option_id)
        ids.reverse!
        expect(model.correct?(ids)).to be_truthy
      end

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
    end
  end

  shared_examples 'in order way' do
    context 'with correct?' do
      let(:ids) { model.correct_answers.order { index }.pluck(:answer_option_id) }

      it do
        expect(model.correct?(ids)).to be_truthy
      end

      it do
        ids.shift
        expect(model.correct?(ids)).to be_falsey
      end

      it do
        ids = []
        expect(model.correct?(ids)).to be_falsey
      end

      it do
        ids.push(1)
        expect(model.correct?(ids)).to be_falsey
      end

      it do
        ids.reverse!
        expect(model.correct?(ids)).to be_falsey
      end
    end
  end

  #
  # examples
  #

  describe 'create!' do
    let(:model) { @model }
    let(:answer) { @answer }

    context 'boolean' do
      context 'with valid' do
        before :all do
          @model = Qa::Question.create!(
            text: 'q',
            way: Qa::Question.ways[:boolean],
            answers: true
          )
        end

        after :all do
          @model.destroy
        end

        it_behaves_like 'boolean way'
      end

      context 'with invalid' do
        it 'answer boolean required' do
          expect {
            Qa::Question.create!(
              text: 'q',
              way: Qa::Question.ways[:boolean],
              answers: ''
            )
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context 'free text' do
      context 'with valid' do
        before :all do
          @answer = SecureRandom.hex(4)
          @model = Qa::Question.create!(
            text: 'q',
            way: Qa::Question.ways[:free_text],
            answers: @answer
          )
        end

        after :all do
          @model.destroy
        end

        it_behaves_like 'free text way'
      end

      context 'with invalid' do
        it 'answer text required' do
          expect {
            Qa::Question.create!(
              text: 'q',
              way: Qa::Question.ways[:free_text],
              answers: ''
            )
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    #
    # 選択肢系問題のparamsセット
    #

    def choice_param
      {text: 'q',
       way: Qa::Question.ways[:choice],
       options: [
         {index: 0, text: SecureRandom.hex(4)},
         {index: 1, text: SecureRandom.hex(4)},
         {index: 2, text: SecureRandom.hex(4)},
         {index: 3, text: SecureRandom.hex(4)},
       ],
       answers: [
         {index: 1}
       ]
      }
    end

    context 'choice' do
      context 'with valid' do
        before :all do
          @answer = SecureRandom.hex(4)
          @model = Qa::Question.create!(**choice_param)
        end

        after :all do
          @model.destroy
        end

        it_behaves_like 'choice way'
      end

      context 'with invalid' do
        it 'invalid index' do
          expect {
            Qa::Question.create!(**choice_param.merge(answers: [{index: 5}]))
          }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'too many answers' do
          expect {
            Qa::Question.create!(**choice_param.merge(answers: [{index: 1}, {index: 2}]))
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context 'choices' do
      context 'with valid' do
        before :all do
          @answer = SecureRandom.hex(4)
          @model = Qa::Question.create!(**choice_param.merge(
                                          way: Qa::Question.ways[:choices],
                                          answers: [{index: 1}, {index: 2}]
                                        ))
        end

        after :all do
          @model.destroy
        end

        it_behaves_like 'choices way'
      end

      context 'with invalid' do
        it 'invalid index' do
          expect {
            Qa::Question.create!(**choice_param.merge(
                                   way: Qa::Question.ways[:choices],
                                   answers: [{index: 5}]
                                 ))
          }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'too many answers' do
          expect {
            Qa::Question.create!(**choice_param.merge(
                                   way: Qa::Question.ways[:choices],
                                   answers: [{index: 1}, {index: 1}, {index: 1}, {index: 1}, {index: 1}]
                                 ))
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context 'in order' do
      before :all do
        @answer = SecureRandom.hex(4)
        @model = Qa::Question.create!(**choice_param.merge(
                                        way: Qa::Question.ways[:in_order],
                                        answers: [{index: 1}, {index: 3}, {index: 1}, {index: 3}]
                                      ))
      end

      after :all do
        @model.destroy
      end

      it_behaves_like 'in order way'

      context 'with invalid' do
        it 'invalid index' do
          expect {
            Qa::Question.create!(**choice_param.merge(
                                   way: Qa::Question.ways[:in_order],
                                   answers: [{index: 5}]
                                 ))
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  describe 'answer the question' do
    #
    # フリーテキスト、ox以外は選択肢が必要
    #

    before :all do
      @model = create(:qa_question, :valid, way: Qa::Question.ways[:choices])
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

    context 'with "choice" way' do
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

      it_behaves_like 'choice way'
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

      it_behaves_like 'choices way'
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

      it_behaves_like 'in order way'
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
        model.save!
        5.times do
          model.answer_options.create(attributes_for(:qa_answer_option, :valid_attr))
        end
      end

      context 'when not included answer options' do
        before :each do
          model.correct_answers.create(attributes_for(:qa_correct_answer, :valid_attr))
        end

        it { expect(model.valid?).to be_falsey }
        it { expect(model.save).to be_falsey }
        it { expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid) }
      end

      context 'when included answer options' do
        before :each do
          model.correct_answers.create(
            attributes_for(
              :qa_correct_answer, :valid_attr,
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
