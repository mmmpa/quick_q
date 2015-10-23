var search_data = {"index":{"searchIndex":["applicationcontroller","applicationhelper","createquestion","creationfailed","invalidtype","noparameter","qa","answeroption","correctanswer","explanation","question","call()","correct?()","create_from_array!()","detect_ox()","detect_way()","execute()","from()","new()","new()","normalize_answer!()","normalize_csv_to()","normalize_explanation!()","normalize_json_hash()","normalize_options!()","normalize_text!()","normalize_type!()","result()","table_name_prefix()","to_free_text()","to_ox()","readme"],"longSearchIndex":["applicationcontroller","applicationhelper","createquestion","createquestion::creationfailed","createquestion::invalidtype","createquestion::noparameter","qa","qa::answeroption","qa::correctanswer","qa::explanation","qa::question","createquestion::call()","qa::question#correct?()","createquestion#create_from_array!()","createquestion::detect_ox()","createquestion::detect_way()","createquestion#execute()","createquestion::from()","createquestion::new()","createquestion::creationfailed::new()","createquestion::normalize_answer!()","createquestion::normalize_csv_to()","createquestion::normalize_explanation!()","createquestion::normalize_json_hash()","createquestion::normalize_options!()","createquestion::normalize_text!()","createquestion::normalize_type!()","createquestion::creationfailed#result()","qa::table_name_prefix()","createquestion::to_free_text()","createquestion::to_ox()",""],"info":[["ApplicationController","","ApplicationController.html","",""],["ApplicationHelper","","ApplicationHelper.html","",""],["CreateQuestion","","CreateQuestion.html","","<p>webからの入力以外からQa::Questionを作成する\n<p>Example\n\n<pre>CreateQuestion.(hash)\nCreateQuestion.from(json: json)\nCreateQuestion.from(csv: ...</pre>\n"],["CreateQuestion::CreationFailed","","CreateQuestion/CreationFailed.html","",""],["CreateQuestion::InvalidType","","CreateQuestion/InvalidType.html","",""],["CreateQuestion::NoParameter","","CreateQuestion/NoParameter.html","",""],["Qa","","Qa.html","",""],["Qa::AnswerOption","","Qa/AnswerOption.html","","<p>問題の選択肢をあらわすモデル 直接操作はしない\n<p># アソシエーション\n<p>question 自分が属する問題 correct_answers 自分を参照する正答。inverse_of対応のため\n"],["Qa::CorrectAnswer","","Qa/CorrectAnswer.html","","<p>正答をあらわすモデル 直接操作はしない\n<p># アソシエーション\n<p>question 自分が属する問題 answer_options 自分、つまり正答の内容をあらわす選択肢\n"],["Qa::Explanation","","Qa/Explanation.html","","<p>問題の解説文をあらわすモデル 直接操作はしない\n<p># アソシエーション\n<p>question 自分が属する問題\n"],["Qa::Question","","Qa/Question.html","","<p>問題を統括するモデル\n<p>Attributes\n<p>アソシエーション用の値を一時保持する。\n"],["call","CreateQuestion","CreateQuestion.html#method-c-call","(options = {})",""],["correct?","Qa::Question","Qa/Question.html#method-i-correct-3F","(answer)","<p>答え合わせ\n"],["create_from_array!","CreateQuestion","CreateQuestion.html#method-i-create_from_array-21","()",""],["detect_ox","CreateQuestion","CreateQuestion.html#method-c-detect_ox","(ox)",""],["detect_way","CreateQuestion","CreateQuestion.html#method-c-detect_way","(type_text)",""],["execute","CreateQuestion","CreateQuestion.html#method-i-execute","()",""],["from","CreateQuestion","CreateQuestion.html#method-c-from","(options = {})",""],["new","CreateQuestion","CreateQuestion.html#method-c-new","(options = {})",""],["new","CreateQuestion::CreationFailed","CreateQuestion/CreationFailed.html#method-c-new","(result)",""],["normalize_answer!","CreateQuestion","CreateQuestion.html#method-c-normalize_answer-21","(question)",""],["normalize_csv_to","CreateQuestion","CreateQuestion.html#method-c-normalize_csv_to","(way, csv_lines)",""],["normalize_explanation!","CreateQuestion","CreateQuestion.html#method-c-normalize_explanation-21","(question)",""],["normalize_json_hash","CreateQuestion","CreateQuestion.html#method-c-normalize_json_hash","(json_hash)",""],["normalize_options!","CreateQuestion","CreateQuestion.html#method-c-normalize_options-21","(options)",""],["normalize_text!","CreateQuestion","CreateQuestion.html#method-c-normalize_text-21","(question)",""],["normalize_type!","CreateQuestion","CreateQuestion.html#method-c-normalize_type-21","(question)",""],["result","CreateQuestion::CreationFailed","CreateQuestion/CreationFailed.html#method-i-result","()",""],["table_name_prefix","Qa","Qa.html#method-c-table_name_prefix","()",""],["to_free_text","CreateQuestion","CreateQuestion.html#method-c-to_free_text","(line)",""],["to_ox","CreateQuestion","CreateQuestion.html#method-c-to_ox","(line)",""],["README","","README_rdoc.html","",""]]}}