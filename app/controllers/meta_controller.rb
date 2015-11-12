class MetaController < ApplicationController
  def site_map
    render plain: urls.join("\n")
  end

  def urls
    result = []

    result << portal_url

    Qa::Tag.find_each do |tag|
      next if tag.questions.size == 0
      result << api_tagged_questions_url(tag.id).gsub('/api', '')
    end

    Qa::Question.find_each do |q|
      result << api_question_url(q.id).gsub('/api', '')
    end

    result
  end
end
