require 'rails_helper'

module Api
  RSpec.describe "Tags", type: :request do
    before :all do
      @q = File.read("#{Rails.root}/spec/fixtures/tagged/q.csv")
      Qa::Question.destroy_all
      CoordinateQuestion.from(csv: @q, way: :free_text)
      @q_ids = Qa::Question.pluck(:id)

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

    let(:tag1) { Qa::Tag.find_by(name: :tag1).id }
    let(:tag2) { Qa::Tag.find_by(name: :tag2).id }
    let(:tag3) { Qa::Tag.find_by(name: :tag3).id }
    let(:tag4) { Qa::Tag.find_by(name: :tag4).id }
    let(:tag5) { Qa::Tag.find_by(name: :tag5).id }
    let(:tag5) { Qa::Tag.find_by(name: :tag6).id }

    describe 'indexing' do
      let(:result_hash) { JSON.parse(response.body) }
      let(:ids) { result_hash.map { |r| r['id'] } }
      let(:counts) { result_hash.map { |r| r['count'] } }

      before :each do
        get api_tags_path
      end

      it do
        expect(response).to have_http_status(200)
        expect(result_hash.size).to eq(Qa::Tag.count)
        expect(ids).to match_array(Qa::Tag.pluck(:id))
        expect(counts).to eq([4, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
      end
    end

    describe 'tags of question' do
      let(:result_hash) { JSON.parse(response.body) }
      let(:ids) { result_hash.map { |r| r['id'] } }

      it do
        get api_question_tags_path(@q_ids[0])
        expect(response).to have_http_status(200)
        expect(ids).to match_array([tag1])
      end

      it do
        get api_question_tags_path(@q_ids[1])
        expect(response).to have_http_status(200)
        expect(ids).to match_array([tag2])
      end

      it do
        get api_question_tags_path(@q_ids[4])
        expect(response).to have_http_status(200)
        expect(ids).to match_array([tag1, tag2, tag3])
      end

      it do
        get api_question_tags_path(@q_ids[9])
        expect(response).to have_http_status(200)
        expect(ids).to match_array([])
      end
    end

    describe 'tags on tags' do
      let(:result_hash) { JSON.parse(response.body) }
      let(:ids) { result_hash.map { |r| r['id'] } }
      let(:counts) { result_hash.map { |r| r['count'] } }

      it do
        get api_tagged_tag_path(tag1)
        expect(response).to have_http_status(200)
        expect(counts).to eq([4, 2, 2])
      end

      it do
        get api_tagged_tag_path(tag3)
        expect(response).to have_http_status(200)
        expect(counts).to eq([2, 1, 3])
      end

      it do
        get api_tagged_tag_path([tag1, tag2].join(','))
        expect(response).to have_http_status(200)
        expect(counts).to eq([2, 2, 1])
      end

      it do
        get api_tagged_tag_path([tag1, tag2, tag3].join(','))
        expect(response).to have_http_status(200)
        expect(counts).to eq([1, 1, 1])
      end
    end
  end
end