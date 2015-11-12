require 'rails_helper'

module Api
  RSpec.describe "Tagged", type: :request do
    before :all do
      @q = File.read("#{Rails.root}/spec/fixtures/tagged/q.csv")
      Qa::Question.destroy_all
      CoordinateQuestion.from(csv: @q, way: :free_text)

      @ids = Qa::Question.pluck(:id)

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

    describe 'next question' do
      let(:result_hash) { JSON.parse(response.body) }

      it do
        get api_tagged_next_path(tags: tag1, id: @ids[0])
        expect(result_hash['next']['id']).to eq(@ids[2])
        expect(result_hash['prev']).to be_nil
      end
    end

    describe 'indexing' do
      let(:result_hash) { JSON.parse(response.body) }
      let(:names) { result_hash.map { |r| r['text'] } }

      it do
        get api_tagged_questions_path(tag1)
        expect(names).to match_array(%w(1 3 4 5))
      end

      it do
        get api_tagged_questions_path(tag2)
        expect(names).to match_array(%w(2 3 5))
      end

      it do
        get api_tagged_questions_path(tag3)
        expect(names).to match_array(%w(4 5 6))
      end

      it do
        get api_tagged_questions_path([tag1, tag2].join(','))
        expect(names).to match_array(%w(3 5))
      end

      it do
        get api_tagged_questions_path([tag1, tag3].join(','))
        expect(names).to match_array(%w(4 5))
      end

      it do
        get api_tagged_questions_path([tag1, tag2, tag3].join(','))
        expect(names).to match_array(%w(5))
      end
    end
  end
end