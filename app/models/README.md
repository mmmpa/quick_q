# Qa

問題のためのネームスペース

## Question

問題を統括するモデル。

問題文、管理用の識別子が主要な属性。

Qa以下のモデルに対する操作は全ての操作はここから行われる。

Explanation、AnswerOption、CorrectAnswerは全てQuestionとともに生まれ、ともに消える。

## Explanation

問題解説。

## AnswerOption

問題の答えの選択肢。

## CorrectAnswer

AnswerOption選択肢に対して関連を持つ。

# Challenge

ユーザーが問題に挑戦するときのセッションをあらわすネームスペース。

## Game

挑戦自体をあらわすモデル。

挑戦内容によって保持する内容がちがう。

短命モデルなので**redis-objects**を使う。

## Selection

特定の数の問題をワンセットとして挑戦する。

答えあわせは終了時。

正答数が表示される。

## Workbook

問題集に挑戦する。

答えあわせは終了時。

合格不合格の概念がある。評価は問題集の設定による。

## Wheel

ユーザーが終了するまで問題を出しつづける。

答えあわせは都度。

正答パーセンテージが表示される。

# Workbook

## Book

問題集の設定をもつ。

評価方法、合格点数、問題集のタイトル、管理用の識別子。

問題はBook::Questionを交差テーブルとして用いて保持する。

## Question

問題集における問題の点数、インデックスを保持する。

Qa::Questionへの関連をもつ。
