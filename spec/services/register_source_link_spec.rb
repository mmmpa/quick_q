require 'rails_helper'

RSpec.describe RegisterSourceLink, type: :model do
  describe 'register' do
    context 'with valid csv' do
      before :all do
        @csv = File.read("#{Rails.root}/spec/fixtures/source_link.csv")
        Qa::SourceLink.destroy_all
        RegisterSourceLink.(@csv)
      end

      after :all do
        Qa::SourceLink.destroy_all
      end

      it { expect(Qa::SourceLink.count).to eq(4) }
      it { expect(Qa::SourceLink.all[0].name).to eq('fe') }
      it { expect(Qa::SourceLink.all[1].name).to eq('27_a') }
      it { expect(Qa::SourceLink.all[2].name).to eq('27_a_st') }
      it { expect(Qa::SourceLink.all[0].display).to eq('27::FE') }
      it { expect(Qa::SourceLink.all[2].display).to eq('ST') }

      it do
        expect {
          RegisterSourceLink.(@csv)
        }.not_to change(Qa::SourceLink, :count)
      end
    end
  end
end

