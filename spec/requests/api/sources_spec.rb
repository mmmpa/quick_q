require 'rails_helper'

RSpec.describe "Api::Sources", type: :request do
  describe "GET /api_sources" do
    it "works! (now write some real specs)" do
      get api_sources_path
      expect(response).to have_http_status(200)
    end
  end
end
