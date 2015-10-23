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

  shared_examples 'ox question' do
    it { expect(model.ox?).to be_truthy }
    it { expect(model.correct_answers.size).to eq(1) }
    it { expect(model.answer_options.size).to eq(2) }
    it { expect(model.answer_options.pluck(:text)).to match_array(['o', 'x']) }

    context 'with correct?' do
      it { expect(model.correct?(true)).to be_truthy }
      it { expect(model.correct?(false)).to be_falsey }
    end
  end

  shared_examples 'free text question' do
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

  shared_examples 'single choide question' do
    it { expect(model.single_choice?).to be_truthy }
    it { expect(model.correct_answers.size).to eq(1) }
    it { expect(model.answer_options.size).to eq(4) }

    context 'with correct?' do
      it do
        ids = model.correct_answers.pluck(:answer_option_id)
        expect(model.correct?(ids)).to be_truthy
      end

      it 'no answer' do
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

  shared_examples 'multiple choices question' do
    it { expect(model.multiple_choices?).to be_truthy }
    it { expect(model.answer_options.size).to eq(4) }

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

  shared_examples 'in order question' do
    it { expect(model.in_order?).to be_truthy }
    it { expect(model.answer_options.size).to eq(4) }

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
  # 選択肢系問題のparamsセット
  #

  def choice_param(way_name)
    {
      way: Qa::Question.ways[way_name],
      text: 'q',
      options: [
        {text: SecureRandom.hex(4)},
        {text: SecureRandom.hex(4)},
        {text: SecureRandom.hex(4)},
        {text: SecureRandom.hex(4)},
      ]
    }
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
            way: Qa::Question.ways[:ox],
            answers: true
          )
        end

        after :all do
          @model.destroy
        end

        it_behaves_like 'ox question'
      end

      context 'with invalid' do
        it 'answer boolean required' do
          expect {
            Qa::Question.create!(
              text: 'q',
              way: Qa::Question.ways[:ox],
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

        it_behaves_like 'free text question'
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

    context 'choice' do
      context 'with valid' do
        before :all do
          params = choice_param(:single_choice)
          params[:options][1][:correct_answer] = true

          @model = Qa::Question.create!(**params)
        end

        after :all do
          @model.destroy
        end

        it_behaves_like 'single choide question'
      end

      context 'with invalid' do
        it 'no correct answer' do
          expect {
            params = choice_param(:single_choice)
            Qa::Question.create!(**params)
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context 'multiple_choices' do
      context 'with valid' do
        before :all do
          params = choice_param(:multiple_choices)
          params[:options][1][:correct_answer] = true
          params[:options][3][:correct_answer] = true

          @model = Qa::Question.create!(**params)
        end

        after :all do
          @model.destroy
        end

        it_behaves_like 'multiple choices question'
      end
    end

    context 'in order' do
      before :all do
        params = choice_param(:in_order)
        params[:order] = [0, 3, 3, 2]
        @model = Qa::Question.create!(params)
      end

      after :all do
        @model.destroy
      end

      it_behaves_like 'in order question'

      context 'with invalid' do
        it 'no correct answer' do
          expect {
            params = choice_param(:in_order)
            Qa::Question.create!(**params)
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  describe 'update!' do
    let(:model) { @model }
    let(:answer) { @answer }

    context 'not update' do
      before :all do
        @model = create(:qa_question, :valid)
      end

      after :all do
        @model.destroy
      end

      it_behaves_like 'single choide question'
    end

    context 'to free text' do
      before :all do
        @answer = SecureRandom.hex(4)
        @model = create(:qa_question, :valid)
        @model.update!(
          text: 'q',
          way: Qa::Question.ways[:free_text],
          answers: @answer
        )
      end

      after :all do
        @model.destroy
      end

      it_behaves_like 'free text question'
    end

    context 'to ox' do
      before :all do
        @answer = SecureRandom.hex(4)
        @model = create(:qa_question, :valid)
        @model.update!(
          text: 'q',
          way: Qa::Question.ways[:ox],
          answers: true
        )
      end

      after :all do
        @model.destroy
      end

      it_behaves_like 'ox question'
    end

    context 'to multiple choices' do
      before :all do
        params = choice_param(:multiple_choices)
        params[:options][1][:correct_answer] = true
        params[:options][3][:correct_answer] = true

        @model = create(:qa_question, :valid)
        params[:options][1][:id] = @model.answer_options[0].id
        params[:options][3][:id] = @model.answer_options[1].id
        params[:options][2][:id] = @model.answer_options[2].id
        params[:options][0][:id] = @model.answer_options[3].id
        @params = params.deep_dup
        @model.update!(**params)
      end

      after :all do
        @model.destroy
      end

      it_behaves_like 'multiple choices question'

      it { expect(Qa::AnswerOption.find(@params[:options][0][:id])).to be_a(Qa::AnswerOption) }
      it { expect(Qa::AnswerOption.find(@params[:options][1][:id])).to be_a(Qa::AnswerOption) }
      it { expect(Qa::AnswerOption.find(@params[:options][2][:id])).to be_a(Qa::AnswerOption) }
      it { expect(Qa::AnswerOption.find(@params[:options][3][:id])).to be_a(Qa::AnswerOption) }
    end

    context 'to in order' do
      before :all do
        params = choice_param(:in_order)
        params[:order] = [0, 3, 3, 2]

        @model = create(:qa_question, :valid)
        params[:options][0][:id] = @model.answer_options[0].id
        params[:options][2][:id] = @model.answer_options[2].id
        @params = params.deep_dup
        @model.update!(**params)
      end

      after :all do
        @model.destroy
      end

      it_behaves_like 'in order question'

      it { expect(Qa::AnswerOption.find(@params[:options][0][:id])).to be_a(Qa::AnswerOption) }
      it { expect(Qa::AnswerOption.find(@params[:options][2][:id])).to be_a(Qa::AnswerOption) }
    end

    context 'to choice' do
      before :all do
        params = choice_param(:in_order)
        params[:order] = [0, 3, 3, 2]

        @model = create(:qa_question, :valid)
        @model.update!(**params)
        @model.answer_options(true)

        params2 = choice_param(:single_choice)
        params2[:options][0][:correct_answer] = true
        params2[:options][1][:id] = @model.answer_options[1].id
        params2[:options][2][:id] = @model.answer_options[2].id
        @params2 = params2.deep_dup

        @model.update!(params2)

      end

      after :all do
        @model.destroy
      end

      it_behaves_like 'single choide question'

      it { expect(Qa::AnswerOption.find(@params2[:options][1][:id])).to be_a(Qa::AnswerOption) }
      it { expect(Qa::AnswerOption.find(@params2[:options][2][:id])).to be_a(Qa::AnswerOption) }
    end
  end

  describe 'answer the question' do
    #
    # フリーテキスト、ox以外は選択肢が必要
    #

    context 'with "single choice" way' do
      before :each do
        model.way = Qa::Question.ways[:single_choice]
        model.options = [
          {text: SecureRandom.hex(4), correct_answer: true},
          {text: SecureRandom.hex(4)},
          {text: SecureRandom.hex(4)},
          {text: SecureRandom.hex(4)},
        ]
        model.save
      end

      it_behaves_like 'single choide question'
    end

    context 'with "multiple choices" way' do
      before :each do
        model.way = Qa::Question.ways[:multiple_choices]
        model.options = [
          {text: SecureRandom.hex(4), correct_answer: true},
          {text: SecureRandom.hex(4)},
          {text: SecureRandom.hex(4), correct_answer: true},
          {text: SecureRandom.hex(4)},
        ]
        model.save
      end

      it_behaves_like 'multiple choices question'
    end

    context 'with "in_order" way' do
      before :each do
        model.way = Qa::Question.ways[:in_order]
        model.order = [0, 3, 3, 1]
        model.save
      end

      it_behaves_like 'in order question'
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
      context 'when not included answer options' do
        before :each do
          model.save
          model.correct_answers.create(attributes_for(:qa_correct_answer, :valid_attr))
        end

        it { expect(model.valid?).to be_falsey }
        it { expect(model.save).to be_falsey }
        it { expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid) }
      end

      context 'when included answer options' do
        it { expect(model.valid?).to be_truthy }
        it { expect(model.save).to be_truthy }
        it { expect(model.save!).to be_truthy }
      end
    end
  end
end
