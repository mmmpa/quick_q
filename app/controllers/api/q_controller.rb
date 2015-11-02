module Api

  #
  # Qa::Questionのデータを返すAPI
  # indexはページングに対応する。パラメーターはHTTPヘッダーにpage, total
  # デフォルトは
  # page = 1
  # total = 20
  #
  # タグはid

  class QController < BaseController
    def index
      response.headers.merge!(Qa::QuestionIndex.header_information(page, per))
      render json: Qa::QuestionIndex.newer_page(page, per)
    end

    def tagged_index
      response.headers.merge!(Qa::QuestionIndex.header_information(page, per))
      render json: Qa::QuestionIndex.on(*tags).newer_page(page, per)
    end

    def show
      render json: Qa::QuestionOnly.find(params[:id])
    end

    private

    def tags
      pp Array.wrap(params[:tags].split(',')).map(&:to_i).uniq.compact
    end

    def page
      page_num = params[:page].to_i
      page_num > 0 ? page_num : Q_DEFAULT_PAGE
    end

    def per
      per_num = params[:per].to_i
      per_num > 0 ? per_num : Q_DEFAULT_PER
    end
  end
end