module Api
  class SourcesController < BaseController
    def index
      render json: Qa::SourceLink.all
    end

    def show
      render json: Qa::SourceLink.find(params[:id])
    end
  end
end
