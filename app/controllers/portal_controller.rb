require 'slim/include'

class PortalController < ApplicationController
  def index
    pp request.fullpath
    if params[:question_id]
      @question = Qa::Question.find(params[:question_id])
    elsif params[:tags]
      @questions = Qa::QuestionIndex.on(*tags)
    elsif request.fullpath == '/'
      @tags = Qa::Tag.used
    end
  end

  private
  def tags
    Array.wrap(params[:tags].split(',')).map(&:to_i).uniq.compact
  end

end
