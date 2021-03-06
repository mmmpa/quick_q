require 'rails_helper'

class Qa::Tagged < Qa::Question
  include TaggedPicker
end

RSpec.describe Qa::Tagged, type: :model do
  before :all do
    @q = File.read("#{Rails.root}/spec/fixtures/tagged/q.csv")
    Qa::Question.destroy_all
    CoordinateQuestion.from(csv: @q, way: :free_text)

    @tag = File.read("#{Rails.root}/spec/fixtures/tagged/tag.csv")
    Qa::Tag.destroy_all
    RegisterTag.(@tag)

    @tag_to = File.read("#{Rails.root}/spec/fixtures/tagged/tag_to.csv")
    TagQToTag.(@tag_to)

    10.times do
      q = Qa::Question.take
      q.way = Qa::Question.ways[:multiple_questions]
      q.answer_options.destroy_all
      q.correct_answers.destroy_all
      q.save!
      create(:qa_question, :valid, to: q)
    end

    TagQToTag.with_way
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
  let(:single) { Qa::Tag.find_by(name: :way_single_choice).id }

  describe 'premise' do
    it { expect(Qa::Question.count).to eq(20) }
    it { expect(Qa::Tag.count).to eq(12) }
    it { expect(Qa::QuestionsTag.count).to eq(20) }
  end

  describe 'on' do
    it { expect(Qa::Tagged.on(tag1).pluck(:name)).to match_array(%w(q_1 q_3 q_4 q_5)) }
    it { expect(Qa::Tagged.on(tag2).pluck(:name)).to match_array(%w(q_2 q_3 q_5)) }
    it { expect(Qa::Tagged.on(tag3).pluck(:name)).to match_array(%w(q_4 q_5 q_6)) }
    it { expect(Qa::Tagged.on(tag1, tag2).pluck(:name)).to match_array(%w(q_3 q_5)) }
    it { expect(Qa::Tagged.on(tag1, tag3).pluck(:name)).to match_array(%w(q_4 q_5)) }
    it { expect(Qa::Tagged.on(tag1, tag2, tag3).pluck(:name)).to match_array(%w(q_5)) }
    it { expect(Qa::Tagged.on(tag1, tag2, tag3).pluck(:name)).to match_array(%w(q_5)) }
    it { expect(Qa::Tagged.on(single).pluck(:name)).to match_array([]) }
  end
end