module.exports = JSX = {
  loading: require './loading.js'
  main: require './main.js'
  Menu:
    menu: require './menu/menu.js'
  paginator: require './paginator.js'
  portal: require './portal.js'
  Q:
    freeText: require './q/free-text.js'
    inOrder: require './q/in-order.js'
    indexPage: require './q/index-page.js'
    multipleQuestions: require './q/multiple_questions.js'
    ox: require './q/ox.js'
    question: require './q/question.js'
    singleChoice: require './q/single-choice.js'
    tagSelector: require './q/tag-selector.js'
}