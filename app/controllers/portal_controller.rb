require 'slim/include'

class PortalController < ApplicationController
  def index
    if params[:question_id]
      @question = Qa::Question.find(params[:question_id])
    elsif params[:tags]
      @questions = Qa::QuestionIndex.on(*tags)
    end
  end

  private
  def tags
    Array.wrap(params[:tags].split(',')).map(&:to_i).uniq.compact
  end

end
