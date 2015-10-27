module Qa

  #
  # 問題を統括するモデル
  #
  # = Attributes
  #
  # アソシエーション用の値を一時保持する。
  #
  # - answers
  # - options
  # - explanation_text
  # - order
  #
  # === name
  #
  # 人間によってつけられる識別子。
  # jsonなどシステム外部から問題を何かにひもづけたい場合に使う。
  # 指定されない場合はランダムに付与。
  #
  # === way
  #
  # 解答方法の種類をあらわすenum
  #
  # - free_text テキスト入力問題
  # - boolean   ox問題
  # - choice    一つだけ選択する問題
  # - multiple_choices   すべて選択する問題
  # - in_order  順番どおりに選択する問題
  #
  #
  # = Associations
  #
  # - correct_answers この問題の正答をあらわすアソシエーション
  # - answer_options この問題の解答における選択肢をあらわすアソシエーション
  # - explanation 問題の解説。無い場合もある。
  #
  # wayによって扱いが違うので、foo_attributesによる直接的な作成は行わず、
  # answersとoptionsに一時プールして処理する
  #
  # = Qa::Question.create!
  #
  # == Options
  #
  # - way 解答方法。必須。Qa::Question.waysを使う
  # - text 問題文。必須。
  # - answers free_text, ox問題の場合の正答。
  # - options 解答選択肢のhash。{text: '選択肢1', correct_answer: true} # or false
  # - order in_orderの正答順。optionsの*index*で指定する
  #
  # == Examples
  #
  # === テキスト入力
  #
  #   Qa::Question.create!(
  #     way: Qa::Question.ways[:free_text],
  #     text: '問題文',
  #     answers: '正答'
  #   )
  #
  # === ox問題
  #
  #   Qa::Question.create!(
  #     way: Qa::Question.ways[:ox],
  #     text: '問題文',
  #     answers: true # or false
  #   )
  #
  # === 一つだけ選択する問題
  #
  #   Qa::Question.create!(
  #     way: Qa::Question.ways[:single_choice],
  #     text: '問題文',
  #     options: [
  #       {text: '選択肢1', correct_answer: true},
  #       {text: '選択肢2'},
  #       {text: '選択肢3'},
  #       {text: '選択肢4'},
  #     ]
  #   )
  #
  # === すべて選択する問題
  #
  #   Qa::Question.create!(
  #     way: Qa::Question.ways[:multiple_choices],
  #     text: '問題文',
  #     options: [
  #       {text: '選択肢1', correct_answer: true},
  #       {text: '選択肢2'},
  #       {text: '選択肢3', correct_answer: true},
  #       {text: '選択肢4'},
  #     ]
  #   )
  #
  # === 順番どおりに選択する問題
  #
  #   Qa::Question.create!(
  #     way: Qa::Question.ways[:in_order],
  #     text: '問題文',
  #     options: [
  #       {text: '選択肢1'},
  #       {text: '選択肢2'},
  #       {text: '選択肢3'},
  #       {text: '選択肢4'},
  #     ],
  #     order: [0, 3, 3, 2] # 正答のindexを順番どおりに
  #   )
  #

  class Question < ActiveRecord::Base
    BOOLEAN_O = 'o' #:nodoc:
    BOOLEAN_X = 'x' #:nodoc:

    attr_accessor :answers, :options, :explanation_text, :order #:nodoc:

    enum way: {free_text: 10, ox: 20, single_choice: 30, multiple_choices: 40, in_order: 50}

    has_many :correct_answers, dependent: :destroy
    has_many :answer_options, dependent: :destroy
    has_one :explanation, dependent: :destroy
    has_one :pal, dependent: :destroy
    has_one :premise, through: :pal
    has_many :selected, class_name: 'Selection::SelectedQuestion', dependent: :destroy
    has_many :selections, class_name: 'Selection::Selection', through: :selected

    validates :name, :text, :way,
              presence: true

    validates :way,
              inclusion: {in: Question.ways}

    validates :name,
              uniqueness: true

    validate :way_requirement_fulfilled

    before_validation :arrange!

    #
    # 答え合わせ
    #
    # == Options
    #
    # - answer 解答。解答方法によって値がちがう。
    #
    # == Example
    #
    # === テキスト入力
    #
    #   question.correct?('答え')
    #
    # === ox問題
    #
    #   question.correct?(true)
    #   question.correct?('true')
    #   question.correct?(false)
    #   question.correct?('false')
    #
    # === 一つだけ選択する問題
    #
    #   question.correct?(1) # AnswerOption#id
    #
    # === すべて選択する問題
    #
    #   question.correct?([1, 3, 2]) # AnswerOption#id
    #
    # === 順番どおりに選択する問題
    #
    #   question.correct?([1, 3, 3, 2]) # AnswerOption#id
    #
    def correct?(answer)
      normalized = normalized_answer(answer)

      case
        when ox?
          matcher = normalized_boolean(answer) ? BOOLEAN_O : BOOLEAN_X
          correct_answers.first.answer_option.text == matcher
        when in_order?
          # 順序まで完全に同じか
          correct_answers.order { index }.pluck(:answer_option_id) == normalized
        else
          # 正答のみが含まれているか
          corrects = correct_set
          normalized.size == corrects.size && Set.new == (corrects - Set.new(normalized))
      end
    end

    private

    #
    # フリーテキスト、ox問題の場合はcorrectsがcorrect_answersとanswer_optionsに
    # ダイレクトに反映される
    #
    def arrange!
      case
        when free_text?
          arrange_for_free_text!
        when ox?
          arrange_for_boolean!
        else
          arrange_for_choice_way!
      end

      arrange_added_name!
      arrange_explanation!

      sweep_sub_attributes!

      true
    end

    #
    # ステートを維持したままでupdateをかけるとcreateなどの内容が引き継がれるため
    #
    def sweep_sub_attributes!
      [:answers, :options, :explanation_text, :order].each do |name|
        send("#{name}=", nil)
      end
    end

    def arrange_added_name!
      self.name ||= SecureRandom.hex(8)
    end

    def arrange_explanation!
      if explanation_text.blank?
        explanation.try(:destroy)
        return
      end

      if explanation
        explanation.update!(text: explanation_text)
      else
        build_explanation(text: explanation_text)
      end
    end

    def arrange_for_choice_way!
      return if options.blank?

      # 毎回更新
      correct_answers.delete_all
      # 削除分破棄のためリロード
      correct_answers(true)

      # 現在の選択肢と比較してなくなっている分を削除
      now = Set.new(answer_options.pluck(:id))
      newer = options.map { |o| o[:id] }
      (now - newer).each { |id| answer_options.destroy(id) }
      # 削除分破棄のためリロード
      answer_options(true)

      # idがあるものはupdate、無いものはnew
      options.each_with_index do |param, index|
        correct_option = normalized_boolean(param.delete(:correct_answer))
        option_id = param.delete(:id)

        param.merge!(index: index)

        now = begin
          if option_id.present?
            option = answer_options.find(option_id)
            option.update!(param)
            option
          else
            answer_options.build(param)
          end
        end

        if correct_option.present?
          correct_answers.build(answer_option: now, index: index)
        end
      end

      if order.present?
        sorted_options = answer_options.sort_by { |option| option.index }
        order.each_with_index do |option_index, index|
          correct_answers.build(answer_option: sorted_options[option_index], index: index)
        end
      end

      self
    end

    def arrange_for_free_text!
      if answers.blank?
        errors.add(:answers, :blank)
        return
      end

      sweep!
      new_answer = answer_options.build(text: stripped_answers)
      correct_answers.build(answer_option: new_answer)

      self
    end

    def arrange_for_boolean!
      if answers.nil? || answers == ''
        errors.add(:answers, :blank)
        return
      end

      sweep!
      o = answer_options.build(text: BOOLEAN_O)
      x = answer_options.build(text: BOOLEAN_X)
      correct_answers.build(answer_option: normalized_boolean(stripped_answers) ? o : x)

      self
    end

    def correct_answers_included?
      corrects = correct_set
      options = option_set

      corrects == (corrects & options)
    end

    def answer_options_length_valid?
      case
        when free_text?
          answer_options.size == 1
        when ox?
          answer_options.size == 2
        else
          answer_options.size >= 1
      end
    end

    def correct_answers_length_valid?
      case
        when free_text?, single_choice?, ox?
          correct_answers.size == 1
        when multiple_choices?
          correct_answers.size <= answer_options.size
        else
          correct_answers.size >= 1
      end
    end

    def correct_set
      Set.new(correct_answers.pluck(:answer_option_id))
    end

    def stripped_answers
      return answers unless Array === answers

      answers.first
    end

    def normalized_answer(answer)
      if free_text?
        answer_options.where { text == answer }.pluck(:id)
      else
        Array.wrap(answer)
      end
    end

    def normalized_boolean(boolean)
      return boolean if TRUE === boolean || FALSE === boolean

      case boolean.to_s.downcase
        when 'true', '1'
          true
        else
          false
      end
    end

    def option_set
      Set.new(answer_options.pluck(:id))
    end

    def sweep!
      correct_answers.destroy_all
      answer_options.destroy_all
    end

    def way_requirement_fulfilled
      unless answer_options_length_valid?
        errors.add(:answer_options, :length)
      end

      unless correct_answers_included?
        errors.add(:correct_answers, :inclusion)
      end

      unless correct_answers_length_valid?
        errors.add(:correct_answers, :length)
      end
    end
  end
end
