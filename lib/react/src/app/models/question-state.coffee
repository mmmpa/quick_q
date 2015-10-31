#
# Q.QuestionContextのステートを統一する
#
module.exports = class QuestionState
  # 問題表示用にapiを叩いている
  @LOADING = 'loading'

  # 問題が表示され、何も選択されていない
  @ASKING = 'asking'

  # なんらかの回答がなされ、送信できる
  @ASKED = 'asked'

  # 送信用のapiを叩いている
  @SUBMITTING = 'submitting'

  # 結果が帰ってきた
  @MARKED = 'marked'

