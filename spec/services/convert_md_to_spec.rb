require 'rails_helper'

RSpec.describe ConvertMdTo, type: :model do
  describe 'convert to question' do
    before :all do
      Qa::Tag.destroy_all
      @tag = File.read("#{Rails.root}/spec/fixtures/tagged/tag.csv")
      RegisterTag.(@tag)

      create(:qa_source_link, :valid, name: :complex_source)
      create(:qa_premise, :valid, name: :complex_premise)
      @md = File.read("#{Rails.root}/spec/fixtures/complex.md")
    end

    after :all do
      Qa::Question.destroy_all
      Qa::SourceLink.destroy_all
      Qa::Premise.destroy_all
      Qa::Tag.destroy_all
    end

    let(:md) { @md }

    context 'once' do
      it do
        expect {
          ConvertMdTo.questions(md).execute
        }.to change(Qa::Question, :count).by(29)
      end
    end

    describe '各種questionを作成' do
      before :all do
        ConvertMdTo.questions(@md).execute
      end

      after :all do
        Qa::Question.destroy_all
        Qa::SourceLink.destroy_all
        Qa::Premise.destroy_all
      end

      it { expect(Qa::Question.count).to eq(29) }
      it { expect(Qa::Question.free_text.count).to eq(5) }
      it { expect(Qa::Question.ox.count).to eq(5) }
      it { expect(Qa::Question.single_choice.count).to eq(5) }
      it { expect(Qa::Question.multiple_choices.count).to eq(5) }
      it { expect(Qa::Question.in_order.count).to eq(5) }
      it { expect(Qa::Question.multiple_questions.count).to eq(1) }

      it { expect(Qa::Question.multiple_questions.first.premise).to be_truthy }
      it { expect(Qa::Question.multiple_questions.first.source_link).to be_truthy }
      it { expect(Qa::Question.on(Qa::Tag.find_by(name: 'app_test')).to_a.size).to eq(26) }

      it { expect(Qa::Question.free_text.first.correct?(1)).to be_truthy }
      it { expect(Qa::Question.free_text.offset(1).first.correct?(2)).to be_truthy }

      it { expect(Qa::Question.ox.first.correct?(true)).to be_truthy }
      it { expect(Qa::Question.ox.first.correct?(false)).to be_falsey }
      it { expect(Qa::Question.ox.offset(1).first.correct?(false)).to be_truthy }
      it { expect(Qa::Question.ox.offset(1).first.correct?(true)).to be_falsey }


      it do
        q = Qa::Question.single_choice.first
        expect(q.correct?(q.answer_options.order { index }.first.id)).to be_truthy
      end

      it do
        q = Qa::Question.single_choice.offset(1).first
        expect(q.correct?(q.answer_options.order { index }.offset(1).first.id)).to be_truthy
      end

      it do
        q = Qa::Question.multiple_choices.first
        expect(q.correct?(q.answer_options.order { index }.first.id)).to be_truthy
      end

      it do
        q = Qa::Question.multiple_choices.offset(1).first
        ids = q.answer_options.order { index }.pluck(:id)
        expect(q.correct?([ids[0], ids[1]])).to be_truthy
      end

      it do
        q = Qa::Question.in_order.first
        ids = q.answer_options.order { index }.pluck(:id)
        expect(q.correct?([ids[1], ids[2]])).to be_truthy
      end

      it do
        q = Qa::Question.in_order.offset(1).first
        ids = q.answer_options.order { index }.pluck(:id)
        expect(q.correct?([ids[1], ids[2], ids[1]])).to be_truthy
      end

      it do
        q = Qa::Question.multiple_questions.first
        a1 = q.children[0].correct_answers.pluck(:answer_option_id).first
        a2 = q.children[1].correct_answers.pluck(:answer_option_id)
        a3 = q.children[2].correct_answers.pluck(:answer_option_id)
        expect(q.correct?([a1, a2, a3])).to be_truthy
      end

      it do
        expect {
          ConvertMdTo.questions(md).execute
        }.to change(Qa::Question, :count).by(0)
      end
    end
  end

  describe 'convert to multiple questions question' do
    before :all do
      @md = File.read("#{Rails.root}/spec/fixtures/multiple_questions.md")
      @tag = File.read("#{Rails.root}/spec/fixtures/tagged/tag.csv")
      Qa::Tag.destroy_all
      RegisterTag.(@tag)
    end

    after :all do
      Qa::Question.destroy_all
    end

    let(:md) { @md }

    it do
      expect {
        ConvertMdTo.questions(md).execute
      }.to change(Qa::Question, :count).by(3)
    end

    it do
      ConvertMdTo.questions(md).execute
      TagQToTag.with_way

      expect(Qa::QuestionIndex.count).to eq(1)
      expect(Qa::QuestionIndex.on(Qa::Tag.find_by(name: :way_multiple_questions).id).to_a.size).to eq(1)
      expect(Qa::QuestionIndex.on(Qa::Tag.find_by(name: :way_single_choice).id).to_a.size).to eq(0)
    end

    it do
      ConvertMdTo.questions(md).execute

      expect {
        ConvertMdTo.questions(md).execute
      }.to change(Qa::Question, :count).by(0)
    end
  end

  describe 'convert to premise' do
    before :all do
      @md = File.read("#{Rails.root}/spec/fixtures/premises_md.md")
    end

    after :all do
      Qa::Premise.destroy_all
    end

    let(:md) { @md }

    it do
      expect {
        ConvertMdTo.premises(md).execute
      }.to change(Qa::Premise, :count).by(2)
      pp Qa::Premise.all
    end

    it do
      ConvertMdTo.premises(md).execute

      expect {
        ConvertMdTo.premises(md).execute
      }.to change(Qa::Premise, :count).by(0)
    end
  end
end
