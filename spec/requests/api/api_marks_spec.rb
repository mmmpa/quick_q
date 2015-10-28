require 'rails_helper'

module Api
  RSpec.describe "Api::Marks", type: :request do
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

    shared_examples 'response for correct answer' do
      it do
        expect(result_hash.deep_symbolize_keys!).to eq({mark: true, correct_answer: correct_answer})
      end
    end

    shared_examples 'response for incorrect answer' do
      it do
        expect(result_hash.deep_symbolize_keys!).to eq({mark: false, correct_answer: correct_answer})
      end
    end

    describe "POST /api/marks" do
      context 'with short parameter' do
        let(:q) { Qa::Question.free_text.take }
        let(:correct_answer) { q.correct_answers.first.text }

        it do
          post api_mark_path(answers: correct_answer)
          expect(response).to have_http_status(500)
        end

        it do
          post api_mark_path(id: q.id)
          expect(response).to have_http_status(500)
        end
      end

      context 'with invalid id' do
        let(:q) { Qa::Question.free_text.take }
        let(:correct_answer) { q.correct_answers.first.text }

        it do
          post api_mark_path(id: 0, answers: correct_answer)
          expect(response).to have_http_status(404)
        end
      end

      context 'with correct answer' do
        context 'to free text question' do
          let(:q) { Qa::Question.free_text.take }
          let(:correct_answer) { q.correct_answers.first.text }

          it_behaves_like 'response for correct answer' do
            before { post api_mark_path(id: q.id, answers: correct_answer) }
          end
        end

        context 'to ox question' do
          let(:q) { Qa::Question.ox.take }
          let(:correct_answer) { q.correct_answers.first.text }

          it_behaves_like 'response for correct answer' do
            before { post api_mark_path(id: q.id, answers: correct_answer == 'o') }
          end
        end

        context 'to single choice question' do
          let(:q) { Qa::Question.single_choice.take }
          let(:correct_answer) { q.correct_answers.first.answer_option_id }

          it_behaves_like 'response for correct answer' do
            before { post api_mark_path(id: q.id, answers: correct_answer) }
          end
        end

        context 'to multiple choices question' do
          let(:q) { Qa::Question.multiple_choices.take }
          let(:correct_answer) { q.correct_answers.pluck(:answer_option_id) }

          it_behaves_like 'response for correct answer' do
            before { post api_mark_path(id: q.id, answers: correct_answer) }
          end
        end

        context 'to free text question' do
          let(:q) { Qa::Question.in_order.take }
          let(:correct_answer) { q.correct_answers.order { index }.pluck(:answer_option_id) }

          it_behaves_like 'response for correct answer' do
            before { post api_mark_path(id: q.id, answers: correct_answer) }
          end
        end
      end

      context 'with incorrect answer' do
        context 'to free text question' do
          let(:q) { Qa::Question.free_text.take }
          let(:correct_answer) { q.correct_answers.first.text }

          it_behaves_like 'response for incorrect answer' do
            before { post api_mark_path(id: q.id, answers: '') }
          end
        end

        context 'to ox question' do
          let(:q) { Qa::Question.ox.take }
          let(:correct_answer) { q.correct_answers.first.text }

          it_behaves_like 'response for incorrect answer' do
            before { post api_mark_path(id: q.id, answers: correct_answer != 'o') }
          end
        end

        context 'to single choice question' do
          let(:q) { Qa::Question.single_choice.take }
          let(:correct_answer) { q.correct_answers.first.answer_option_id }

          it_behaves_like 'response for incorrect answer' do
            before { post api_mark_path(id: q.id, answers: 0) }
          end
        end

        context 'to multiple choices question' do
          let(:q) { Qa::Question.multiple_choices.take }
          let(:correct_answer) { q.correct_answers.pluck(:answer_option_id) }

          it_behaves_like 'response for incorrect answer' do
            before { post api_mark_path(id: q.id, answers: [0]) }
          end
        end

        context 'to free text question' do
          let(:q) { Qa::Question.in_order.take }
          let(:correct_answer) { q.correct_answers.order { index }.pluck(:answer_option_id) }

          it_behaves_like 'response for incorrect answer' do
            before { post api_mark_path(id: q.id, answers: [0]) }
          end
        end
      end
    end
  end
end
