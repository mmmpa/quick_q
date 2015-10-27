require 'rails_helper'

RSpec.describe "Api::Qs", type: :request do
  before :all do
    @csv = File.read("#{Rails.root}/spec/fixtures/text.csv")
    Qa::Question.destroy_all
    CoordinateQuestion.from(csv: @csv, way: :free_text)
  end

  after :all do
    Qa::Question.destroy_all
  end

  let(:random_id) { (rand(1..Qa::Question.count))}
  let!(:model) { random_id ? Qa::Question.find(random_id) : (raise 'not yet ready') }

  describe "GET /api/q" do
    it do
      get api_questions_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /api/q/:id" do
    it do
      get "/api/q/#{random_id}"
      pp response.body, "/api/q/#{random_id}"
      expect(response).to have_http_status(200)
    end
  end
end
