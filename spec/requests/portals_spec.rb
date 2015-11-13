require 'rails_helper'

RSpec.describe "Portals", type: :request do
  before :all do
    Qa::Question.destroy_all
    Qa::Tag.destroy_all

    @tag = File.read("#{Rails.root}/spec/fixtures/tagged/tag.csv")
    RegisterTag.(@tag)

    @md = File.read("#{Rails.root}/spec/fixtures/complex.md")
    ConvertMdTo.questions(@md, update: true).execute

    @all_ids = Qa::Question.order { updated_at.desc }.pluck(:id)
  end

  after :all do
    Qa::Question.destroy_all
    Qa::Tag.destroy_all
  end

  describe 'get /' do
    it 'render all tags' do
      get '/'

      expect(response).to have_http_status(200)
      expect(response.body).to have_tag('ul.all-tags li', count: Qa::Tag.count)
    end
  end

  describe 'get /q/:question_id' do
    it do
      q = Qa::Question.take
      get question_path(q.id)
      expect(response).to have_http_status(200)
      expect(response.body).to have_tag('ul.tags li', count: q.tags.count)
      expect(response.body).to have_tag('div.question-text', content: q.text)
    end
  end

  describe 'get /q/tagged/:tags' do
    it do
      q = Qa::Question.take
      get tags_path(q.tags.first.id)
      expect(response).to have_http_status(200)
      expect(response.body).to have_tag('ul.questions li', count: Qa::Question.on(q.tags.first.id).to_a.size)
    end
  end
end
