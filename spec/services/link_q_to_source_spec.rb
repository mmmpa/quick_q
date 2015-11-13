require 'rails_helper'

RSpec.describe LinkQToSource, type: :model do
  describe 'register' do
    context 'with valid csv' do
      before :all do
        @q = File.read("#{Rails.root}/spec/fixtures/text.csv")
        Qa::Question.destroy_all
        CoordinateQuestion.from(csv: @q, way: :free_text)

        @src = File.read("#{Rails.root}/spec/fixtures/source_link.csv")
        Qa::SourceLink.destroy_all
        RegisterSourceLink.(@src)

        @link = File.read("#{Rails.root}/spec/fixtures/link_to.csv")
        LinkQToSource.(@link)
      end

      after :all do
        Qa::Question.destroy_all
        Qa::SourceLink.destroy_all
      end

      it { expect(Qa::Question.all[0].source_link.name).to eq('27_a_st') }
      it { expect(Qa::Question.all[1].source_link.name).to eq('27_a_st') }
      it { expect(Qa::Question.all[2].source_link.name).to eq('27_a_st') }
      it { expect(Qa::Question.all[3].source_link.name).to eq('27_a_sa') }
      it { expect(Qa::Question.all[4].source_link).to be_falsey }

      it do
        expect {
          LinkQToSource.(@link)
        }.not_to change(Qa::SourceLink, :count)
      end
    end

    context 'with invalid csv' do
      it do
        expect {
          LinkQToSource.('a,')
        }.not_to change(Qa::SourceLink, :count)
      end
    end
  end
end

