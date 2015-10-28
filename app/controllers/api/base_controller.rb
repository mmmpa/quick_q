module Api
  class BaseController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound,
                with: -> { render status: 404, json: {error: 'Not Found'} }

    rescue_from ActionController::ParameterMissing,
                with: -> { render status: 500, json: {error: 'Parameter Missing'} }
  end
end