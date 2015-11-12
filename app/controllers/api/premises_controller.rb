module Api
  class PremisesController < BaseController
    def show
      render json: Qa::Premise.find(params[:id])
    end
  end
end
