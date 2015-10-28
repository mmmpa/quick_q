module Api

  #
  # Qa::Questionの答えを投げると正否を返すAPI
  # Qa::Questionのidと答えが必要。
  #

  class MarksController < BaseController
    #
    # = Return
    #
    # JSONで返る
    #
    #   # テキスト入力、ox
    #   {mark: true, correct_answer: '正答'}
    #
    #   # 選択問題
    #   {mark: true, correct_answer: [1]} # answer_option_id
    #
    # = Parameters
    #
    #   # テキスト入力
    #   {id: 1, answers: '答え'}
    #
    #   # ox問題
    #   {id: 1, answers: true} # or false, 0, 1
    #
    #   # 一つだけ選択する問題
    #   {id: 1, answers: 1}
    #
    #   # すべて選択する問題
    #   {id: 1, answers: [1, 2, 3]}
    #
    #   # 順番どおりに選択する問題
    #   {id: 1, answers: [1, 3, 3, 2]}
    #
    def create
      render json: Qa::QuestionMarker.new(marker_params).mark
    end

    private

    def marker_params
      params.permit!.slice(:id, :answers).tap do |sliced|
        sliced.to_h.deep_symbolize_keys!
        [:id, :answers].each do |required|
          raise ActionController::ParameterMissing.new(sliced) if sliced[required].nil?
        end
      end
    end
  end
end
