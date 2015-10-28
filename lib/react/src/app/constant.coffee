module.exports = Constant =
  classes:
    challengeResultBox: 'col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2'
    textInput: 'form-control size-h3'
    submitButton: 'btn btn-lg btn-success size-h4 wide'
    blueButton: 'btn btn-md btn-primary size-h4'
    greenButton: 'btn btn-md btn-success size-h4'
    indexTable: 'table table-striped table-condensed table-bordered'
    editButton: 'btn btn-md btn-primary size-h6'
    smallBox: 'col-sm-6 col-sm-offset-3 col-md-4 col-md-offset-4'
    workbookChallengeBox: 'col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2'
    questionBox: 'col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2'
    join: (base, added)->
      [Constant.classes[base], added].join(' ')
  render:
    levelLabel: (value)->
      _.find(Constant.levels, (obj)=> obj.value == value).label
    evalType: (value)->
      _.find(Constant.evalTypes, (obj)=> obj.value == value).label
    answerType: (value)->
      _.find(Constant.answerTypes, (obj)=> obj.value == value).label
  swal:
    delete:
      title: "削除します"
      text: "この処理は取り消すことができません"
      type: "warning"
      showCancelButton: true
      confirmButtonColor: "#e51c23"
      confirmButtonText: "削除する"
      closeOnConfirm: true
      cancelButtonText: 'キャンセル'
      allowOutsideClick: true
  codeMirror:
    configuration:
      lineNumbers: true
      mode: "xml",
      htmlMode: true
      lineWrapping: true
