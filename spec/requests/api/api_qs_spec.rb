require 'rails_helper'

module Api
  RSpec.describe "Qs", type: :request do
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

    let(:random_id) { rand(Qa::Question.first.id..Qa::Question.last.id) }
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
        get api_question_path(random_id)
        expect(response).to have_http_status(200)
      end

      it do
        get api_question_path(0)
        expect(response).to have_http_status(404)
      end

      it_behaves_like 'response for no option question' do
        before :each do
          get api_question_path(Qa::Question.free_text.take.id)
        end
      end

      it_behaves_like 'response for no option question' do
        before :each do
          get api_question_path(Qa::Question.ox.take.id)
        end
      end

      it_behaves_like 'response for have options question' do
        before :each do
          get api_question_path(Qa::Question.single_choice.take.id)
        end
      end

      it_behaves_like 'response for have options question' do
        before :each do
          get api_question_path(Qa::Question.multiple_choices.take.id)
        end
      end

      it_behaves_like 'response for have options question' do
        before :each do
          get api_question_path(Qa::Question.in_order.take.id)
        end
      end
    end
  end
end