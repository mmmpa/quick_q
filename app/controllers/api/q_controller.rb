module Api
  class QController < ApplicationController
    def index
      render json: Qa::Question.all
    end

    def show
      render json: Qa::Question.find(params[:id])
    end
  end
end