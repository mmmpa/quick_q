module.exports = MultipleQuestions = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    q = @props.question
    App.JSX.Q.multipleQuestions(
      Fa: App.View.Fa
      SingleChoice: App.View.SingleChoice
      MultipleChoices: App.View.MultipleChoices
      FreeText: App.View.FreeText
      Ox: App.View.Ox
      InOrder: App.View.InOrder
      QuestionState: App.QuestionState
      Loading: App.View.Loading
      children: @props.question.children
      answers: @props.answers || []
      result: @props.result || []
    )
)

