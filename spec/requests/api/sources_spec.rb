require 'rails_helper'

RSpec.describe "Api::Sources", type: :request do
  before :all do
    Qa::SourceLink.destroy_all
    @s1 = create(:qa_source_link, :valid)
    @s2 = create(:qa_source_link, :valid)
    @s3 = create(:qa_source_link, :valid)
  end

  after :all do
    Qa::SourceLink.destroy_all
  end

  let(:result_hash) { JSON.parse(response.body) }

  describe 'get /api/src' do
    it  do
      get api_sources_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'get /api/src/:id' do
    it  do
      get api_source_path(@s1.id)
      expect(response).to have_http_status(200)
      expect(result_hash['id']).to eq(@s1.id)
    end

    it  do
      get api_source_path(@s2.id)
      expect(response).to have_http_status(200)
      expect(result_hash['id']).to eq(@s2.id)
    end

    it  do
      get api_source_path(0)
      expect(response).to have_http_status(404)
    end
  end
end
