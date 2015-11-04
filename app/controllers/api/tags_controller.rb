module Api
  class TagsController < BaseController
    def index
      render json: Qa::TagIndex.index
    end

    def index2
      render json: Qa::TagIndex.brutal_index
    end

    def with_tag
      render json: Qa::TagIndex.with_tag(*tags)
    end

    def with_question
      render json: Qa::Question.find(params[:question_id]).tags
    end

    private

    def tags
      Array.wrap(params[:tags].split(',')).map(&:to_i).uniq.compact
    end
  end
end
