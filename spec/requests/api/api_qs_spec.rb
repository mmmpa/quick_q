require 'rails_helper'

module Api


  RSpec.describe "Qs", type: :request do
    def read_csv(name)
      File.read("#{Rails.root}/spec/fixtures/#{name}.csv")
    end

    before :all do
      Qa::Question.destroy_all
      CoordinateQuestion.from(csv: read_csv(:multiple), way: :multiple_choices)
      CoordinateQuestion.from(csv: read_csv(:single), way: :single_choice)
      CoordinateQuestion.from(csv: read_csv(:ox), way: :ox)
      CoordinateQuestion.from(csv: read_csv(:order), way: :in_order)
      CoordinateQuestion.from(csv: read_csv(:text), way: :free_text)
      @all_ids = Qa::Question.order { updated_at.desc }.pluck(:id)
    end

    after :all do
      Qa::Question.destroy_all
    end

    let(:random_id) { (rand(1..Qa::Question.count)) }
    let!(:model) { random_id ? Qa::Question.find(random_id) : (raise 'not yet ready') }
    let(:result_hash) { JSON.parse(response.body) }
    let(:ids) { result_hash.map { |r| r['id'] } }

    shared_examples 'with default parameter' do
      it do
        expect(response).to have_http_status(200)
        expect(result_hash.size).to eq(Q_DEFAULT_PAR)
        expect(ids).to match_array(@all_ids[0, Q_DEFAULT_PAR])
      end
    end

    describe "GET /api/q" do
      context 'with no parameter' do
        it_behaves_like 'with default parameter' do
          before :each do
            get api_questions_path
          end
        end
      end

      context 'with paging parameter' do
        it do
          get api_questions_path(page: 2)
          expect(response).to have_http_status(200)
          expect(result_hash.size).to eq(@all_ids.size - Q_DEFAULT_PAR)
          expect(ids).to match_array(@all_ids[Q_DEFAULT_PAR, Q_DEFAULT_PAR])
        end

        it do
          get api_questions_path(page: 2, par: 5)
          expect(response).to have_http_status(200)
          expect(result_hash.size).to eq(5)
          expect(ids).to match_array(@all_ids[5, 5])
        end

        it do
          get api_questions_path(par: 100)
          expect(response).to have_http_status(200)
          expect(result_hash.size).to eq(@all_ids.size)
          expect(ids).to match_array(@all_ids)
        end

        it do
          get api_questions_path(page: 100)
          expect(response).to have_http_status(200)
          expect(result_hash.size).to eq(0)
          expect(ids).to match_array([])
        end

        it_behaves_like 'with default parameter' do
          before :each do
            get api_questions_path(page: -1)
          end
        end

        it_behaves_like 'with default parameter' do
          before :each do
            get api_questions_path(par: -1)
          end
        end
      end
    end

    describe "GET /api/q/:id" do
      it do
        get api_question_path(1)
        expect(response).to have_http_status(200)
        pp result_hash
      end

      it do
        get api_question_path(6)
        expect(response).to have_http_status(200)
        pp result_hash
      end

      it do
        get api_question_path(11)
        expect(response).to have_http_status(200)
        pp result_hash
      end

      it do
        get api_question_path(16)
        expect(response).to have_http_status(200)
        pp result_hash
      end

      it do
        get api_question_path(21)
        expect(response).to have_http_status(200)
        pp result_hash
      end
    end
  end
end