module Api
  class TagsController < BaseController
    def index
      render json: Qa::TagIndex.with_count
    end
  end
end
