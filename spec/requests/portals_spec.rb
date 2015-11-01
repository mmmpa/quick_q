require 'rails_helper'

RSpec.describe "Portals", type: :request do
  describe "GET /" do
    it do
      get '/'
      expect(response).to have_http_status(200)
    end
  end
end
