module Api

  #
  # Qa::Questionのデータを返すAPI
  # indexはページングに対応する。パラメーターはHTTPヘッダーにpage, total
  # デフォルトは
  # page = 1
  # total = 20
  #

  class QController < BaseController
    def index
      render json: Qa::QuestionIndex.newer_page(page, par)
    end

    def show
      render json: Qa::QuestionOnly.find(params[:id])
    end

    private

    def page
      page_num = params[:page].to_i
      page_num > 0 ? page_num : Q_DEFAULT_PAGE
    end

    def par
      par_num = params[:par].to_i
      par_num > 0 ? par_num : Q_DEFAULT_PAR
    end
  end
end