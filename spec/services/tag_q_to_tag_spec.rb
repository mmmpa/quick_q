require 'rails_helper'

RSpec.describe TagQToTag, type: :model do
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
  end
end

