class Api::PremisesController < ApplicationController
  def show
    render json: Qa::Premise.find(params[:id])
  end
end
