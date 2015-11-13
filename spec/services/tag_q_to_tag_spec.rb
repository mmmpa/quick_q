require 'rails_helper'

RSpec.describe TagQToTag, type: :model do
  describe 'register way' do
    before :all do
      @q = File.read("#{Rails.root}/spec/fixtures/text.csv")
      Qa::Question.destroy_all

      CoordinateQuestion.from(csv: @q, way: :free_text)
      Qa::QuestionsTag.destroy_all
    end

    after :all do
      Qa::Question.destroy_all
      Qa::Tag.destroy_all
    end


    context 'when tag not exist' do
      it do
        expect {
          TagQToTag.with_way
        }.to change(Qa::QuestionsTag, :count).by(0)
      end
    end

    context 'with tag exist' do
      before :all do
        @tag = File.read("#{Rails.root}/spec/fixtures/tag.csv")
        Qa::Tag.destroy_all
        RegisterTag.(@tag)
      end

      after :all do
        Qa::Tag.destroy_all
      end

      it do
        expect {
          TagQToTag.with_way
        }.to change(Qa::QuestionsTag, :count).by(5)
      end

      context 'when children has tag' do
        before :each do
          parent = create(:qa_question, :valid)
          @child = create(:qa_question, :valid, parent: parent)
          @child.tags << Qa::Tag.first
        end

        it do
          TagQToTag.with_way
          expect(@child.tags.count).to eq(0)
        end
      end
    end
  end

  describe 'register' do
    context 'with valid csv' do
      before :all do
        @q = File.read("#{Rails.root}/spec/fixtures/text.csv")
        Qa::Question.destroy_all
        CoordinateQuestion.from(csv: @q, way: :free_text)

        @tag = File.read("#{Rails.root}/spec/fixtures/tag.csv")
        Qa::Tag.destroy_all
        RegisterTag.(@tag)

        @tag_to = File.read("#{Rails.root}/spec/fixtures/tag_to.csv")
        TagQToTag.(@tag_to)
      end

      after :all do
        Qa::Question.destroy_all
        Qa::Tag.destroy_all
      end

      it { expect(Qa::Question.all[0].tags.count).to eq(2) }
      it { expect(Qa::Question.all[1].tags.count).to eq(1) }
      it { expect(Qa::Question.all[2].tags.count).to eq(2) }
      it { expect(Qa::Question.all[3].tags.count).to eq(1) }

      it do
        expect {
          TagQToTag.(@tag_to)
        }.not_to change(Qa::QuestionsTag, :count)
      end
    end

    context 'with invalid csv' do
      it do
        expect {
          TagQToTag.('q,16,tag31')
        }.not_to change(Qa::QuestionsTag, :count)
      end
    end
  end
end

