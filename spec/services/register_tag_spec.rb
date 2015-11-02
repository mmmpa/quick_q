require 'rails_helper'

RSpec.describe RegisterSourceLink, type: :model do
  describe 'register' do
    context 'with valid csv' do
      before :all do
        @csv = File.read("#{Rails.root}/spec/fixtures/tag.csv")
        Qa::Tag.destroy_all
        RegisterTag.(@csv)
      end

      after :all do
        Qa::Tag.destroy_all
      end

      it { expect(Qa::Tag.count).to eq(6) }
      it { expect(Qa::Tag.all[0].name).to eq('way_in_order') }
      it { expect(Qa::Tag.all[2].name).to eq('way') }
      it { expect(Qa::Tag.all[3].name).to eq('multiple_choices') }
      it { expect(Qa::Tag.all[0].display).to eq('順に並べる::問題') }
      it { expect(Qa::Tag.all[2].display).to eq('一つだけ選ぶ問題') }

      it do
        expect {
          RegisterTag.(@csv)
        }.not_to change(Qa::Tag, :count)
      end
    end
  end
end

