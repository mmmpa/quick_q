require 'rails_helper'

module Api
  RSpec.describe "Tags", type: :request do
    before :all do
      @q = File.read("#{Rails.root}/spec/fixtures/tagged/q.csv")
      Qa::Question.destroy_all
      CoordinateQuestion.from(csv: @q, way: :free_text)

      @tag = File.read("#{Rails.root}/spec/fixtures/tagged/tag.csv")
      Qa::Tag.destroy_all
      RegisterTag.(@tag)

      @tag_to = File.read("#{Rails.root}/spec/fixtures/tagged/tag_to.csv")
      TagQToTag.(@tag_to)
    end

    after :all do
      Qa::Question.destroy_all
      Qa::Tag.destroy_all
    end

    describe 'indexing' do
      let(:result_hash) { JSON.parse(response.body) }
      let(:ids) { result_hash.map { |r| r['id'] } }

      before :each do
        get api_tags_path
      end

      it do
        expect(response).to have_http_status(200)
        expect(result_hash.size).to eq(Qa::Tag.count)
        expect(ids).to match_array(Qa::Tag.pluck(:id))
      end
    end

    describe 'index and index2' do
      it do
        get api_tags_path
        result = JSON.parse(response.body)

        get api_tags2_path
        result2 = JSON.parse(response.body)

        expect(result).to match_array(result2)
      end
    end
  end
end