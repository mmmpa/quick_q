require 'rails_helper'

RSpec.describe "Api::Premise", type: :request do
  before :all do
    Qa::Premise.destroy_all
    @s1 = create(:qa_premise, :valid)
    @s2 = create(:qa_premise, :valid)
    @s3 = create(:qa_premise, :valid)
  end

  after :all do
    Qa::Premise.destroy_all
  end

  let(:result_hash) { JSON.parse(response.body) }

  describe 'get /api/premise/:id' do
    it  do
      get api_premise_path(@s1.id)
      expect(response).to have_http_status(200)
      expect(result_hash['id']).to eq(@s1.id)
    end

    it  do
      get api_premise_path(@s2.id)
      expect(response).to have_http_status(200)
      expect(result_hash['id']).to eq(@s2.id)
    end

    it  do
      get api_premise_path(0)
      expect(response).to have_http_status(404)
    end
  end
end
