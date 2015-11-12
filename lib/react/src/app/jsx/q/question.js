module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(AnswerOption, Fa, Loading, QuestionState, answers, goBack, isCorrect, nextQuestions, premise, qTags, question, result, resultText, showQuestion, showTaggedIndex, sourceLink, state, submit) {
      tags.push(React.createElement.apply(React, [ "section", {
        className: "question-q body"
      } ].concat(function() {
        var tags = [];
        tags.push(React.createElement.apply(React, [ "section", {
          className: "question-q tagged-tag-area"
        } ].concat(function() {
          var tags = [];
          qTags ? tags.push(React.createElement("ul", {
            className: "question-q tagged-tag-body"
          }, function() {
            var tags = [];
            var $$obj = qTags;
            if ("number" == typeof $$obj.length) for (var $index = 0, $$l = $$obj.length; $$l > $index; $index++) {
              var tag = $$obj[$index];
              tags.push(React.createElement("li", {
                key: tag.id,
                className: "question-q tagged-tag-tag"
              }, React.createElement(Fa, {
                icon: "tag"
              }), React.createElement("a", {
                href: tag.uri,
                rel: tag.id,
                onClick: showTaggedIndex
              }, React.createElement("span", {
                className: "name"
              }, tag.display))));
            } else {
              var $$l = 0;
              for (var $index in $$obj) {
                $$l++;
                var tag = $$obj[$index];
                tags.push(React.createElement("li", {
                  key: tag.id,
                  className: "question-q tagged-tag-tag"
                }, React.createElement(Fa, {
                  icon: "tag"
                }), React.createElement("a", {
                  href: tag.uri,
                  rel: tag.id,
                  onClick: showTaggedIndex
                }, React.createElement("span", {
                  className: "name"
                }, tag.display))));
              }
            }
            return tags;
          }.call(this))) : tags.push(React.createElement(Loading, {}));
          return tags;
        }.call(this))));
        question.hasPremise() && tags.push(React.createElement.apply(React, [ "section", {
          className: "question-q premise"
        } ].concat(function() {
          var tags = [];
          tags.push(React.createElement("h1", {
            className: "question-q premise-title"
          }, React.createElement(Fa, {
            icon: "file-text-o"
          }), "共通の前文"));
          premise ? tags.push(React.createElement("section", {
            className: "question-q premise-area"
          }, React.createElement("div", {
            dangerouslySetInnerHTML: premise.marked,
            className: "question-q q-text"
          }))) : tags.push(React.createElement(Loading, {}));
          return tags;
        }.call(this))));
        tags.push(React.createElement("section", {
          className: "question-q text"
        }, React.createElement("h1", {
          className: "question-q q"
        }, React.createElement(Fa, {
          icon: "question-circle"
        }), "問題")));
        tags.push(React.createElement("section", {
          className: "question-q question-area"
        }, React.createElement("div", {
          dangerouslySetInnerHTML: question.marked,
          className: "question-q q-text"
        })));
        tags.push(React.createElement("section", {
          className: "question-q answer"
        }, React.createElement("h1", {
          className: "question-q a"
        }, React.createElement(Fa, {
          icon: "exclamation-circle"
        }), question.pleaseText), React.createElement("section", {
          className: "question-q answer-area"
        }, React.createElement(AnswerOption, {
          question: question,
          options: question.options,
          answers: answers,
          result: result
        }))));
        state == QuestionState.MARKED ? tags.push(React.createElement.apply(React, [ "section", {
          className: "question-q result-area"
        } ].concat(function() {
          var tags = [];
          tags.push(React.createElement.apply(React, [ "div", {
            className: "question-q mark-area"
          } ].concat(function() {
            var tags = [];
            isCorrect() ? tags.push(React.createElement("h1", {
              className: "question-q mark correct"
            }, React.createElement(Fa, {
              icon: "thumbs-o-up"
            }), resultText())) : tags.push(React.createElement("h1", {
              className: "question-q mark incorrect"
            }, React.createElement(Fa, {
              icon: "hand-stop-o"
            }), resultText()));
            return tags;
          }.call(this))));
          tags.push(React.createElement("h1", {
            className: "question-q correct-answer"
          }, React.createElement(Fa, {
            icon: "graduation-cap"
          }), "正解は..."));
          question.isMultipleQuestions() ? tags.push(React.createElement("ol", {}, function() {
            var tags = [];
            var $$obj = result;
            if ("number" == typeof $$obj.length) for (var index = 0, $$l = $$obj.length; $$l > index; index++) {
              var mark = $$obj[index];
              tags.push(React.createElement("li", {
                key: index
              }, React.createElement("div", {
                dangerouslySetInnerHTML: mark.correctAnswer,
                className: "question-q answer-area"
              })));
            } else {
              var $$l = 0;
              for (var index in $$obj) {
                $$l++;
                var mark = $$obj[index];
                tags.push(React.createElement("li", {
                  key: index
                }, React.createElement("div", {
                  dangerouslySetInnerHTML: mark.correctAnswer,
                  className: "question-q answer-area"
                })));
              }
            }
            return tags;
          }.call(this))) : tags.push(React.createElement("div", {
            dangerouslySetInnerHTML: result.correctAnswer,
            className: "question-q answer-area"
          }));
          return tags;
        }.call(this)))) : tags.push(React.createElement.apply(React, [ "section", {
          className: "question-q control"
        } ].concat(function() {
          var tags = [];
          state == QuestionState.ASKING ? tags.push(React.createElement("button", {
            disabled: !0,
            className: "question-q button submit disabled"
          }, React.createElement(Fa, {
            icon: "graduation-cap"
          }), " ", question.pleaseText)) : state == QuestionState.ASKED ? tags.push(React.createElement("button", {
            onClick: submit,
            className: "question-q button submit"
          }, React.createElement(Fa, {
            icon: "graduation-cap"
          }), " ", "正解を確認する")) : state == QuestionState.SUBMITTING && tags.push(React.createElement("button", {
            disabled: !0,
            className: "question-q button submit disabled"
          }, React.createElement(Fa, {
            icon: "spinner",
            animation: "pulse"
          }), " ", "確認中..."));
          return tags;
        }.call(this))));
        tags.push(React.createElement.apply(React, [ "section", {
          className: "question-q control-area"
        } ].concat(function() {
          var tags = [];
          tags.push(React.createElement.apply(React, [ "section", {
            className: "question-q next-questions-area"
          } ].concat(function() {
            var tags = [];
            if (nextQuestions) {
              nextQuestions.prevQ && tags.push(React.createElement("button", {
                key: "prevQ",
                rel: nextQuestions.prevQ.id,
                onClick: showQuestion,
                className: "button go-prev"
              }, React.createElement(Fa, {
                icon: "arrow-circle-o-left"
              }), React.createElement("span", {
                className: "name"
              }, "前の問題")));
              nextQuestions.nextQ && tags.push(React.createElement("button", {
                key: "nextQ",
                rel: nextQuestions.nextQ.id,
                onClick: showQuestion,
                className: "button go-next"
              }, React.createElement("span", {
                className: "name"
              }, "次の問題"), React.createElement(Fa, {
                icon: "arrow-circle-o-right"
              })));
            }
            tags.push(React.createElement("button", {
              onClick: goBack,
              className: "button go-back"
            }, React.createElement(Fa, {
              icon: "list"
            }), "一覧にもどる"));
            return tags;
          }.call(this))));
          question.hasSource() && sourceLink && tags.push(React.createElement("section", {
            className: "question-q source-link-area"
          }, React.createElement("h1", {
            className: "question-q source-link-title"
          }, React.createElement(Fa, {
            icon: "link"
          }), "出典"), React.createElement("p", {}, React.createElement(Fa, {
            icon: "link"
          }), React.createElement("a", {
            href: sourceLink.url
          }, sourceLink.display))));
          return tags;
        }.call(this))));
        return tags;
      }.call(this))));
    }).call(this, "AnswerOption" in locals_for_with ? locals_for_with.AnswerOption : typeof AnswerOption !== "undefined" ? AnswerOption : undefined, "Fa" in locals_for_with ? locals_for_with.Fa : typeof Fa !== "undefined" ? Fa : undefined, "Loading" in locals_for_with ? locals_for_with.Loading : typeof Loading !== "undefined" ? Loading : undefined, "QuestionState" in locals_for_with ? locals_for_with.QuestionState : typeof QuestionState !== "undefined" ? QuestionState : undefined, "answers" in locals_for_with ? locals_for_with.answers : typeof answers !== "undefined" ? answers : undefined, "goBack" in locals_for_with ? locals_for_with.goBack : typeof goBack !== "undefined" ? goBack : undefined, "isCorrect" in locals_for_with ? locals_for_with.isCorrect : typeof isCorrect !== "undefined" ? isCorrect : undefined, "nextQuestions" in locals_for_with ? locals_for_with.nextQuestions : typeof nextQuestions !== "undefined" ? nextQuestions : undefined, "premise" in locals_for_with ? locals_for_with.premise : typeof premise !== "undefined" ? premise : undefined, "qTags" in locals_for_with ? locals_for_with.qTags : typeof qTags !== "undefined" ? qTags : undefined, "question" in locals_for_with ? locals_for_with.question : typeof question !== "undefined" ? question : undefined, "result" in locals_for_with ? locals_for_with.result : typeof result !== "undefined" ? result : undefined, "resultText" in locals_for_with ? locals_for_with.resultText : typeof resultText !== "undefined" ? resultText : undefined, "showQuestion" in locals_for_with ? locals_for_with.showQuestion : typeof showQuestion !== "undefined" ? showQuestion : undefined, "showTaggedIndex" in locals_for_with ? locals_for_with.showTaggedIndex : typeof showTaggedIndex !== "undefined" ? showTaggedIndex : undefined, "sourceLink" in locals_for_with ? locals_for_with.sourceLink : typeof sourceLink !== "undefined" ? sourceLink : undefined, "state" in locals_for_with ? locals_for_with.state : typeof state !== "undefined" ? state : undefined, "submit" in locals_for_with ? locals_for_with.submit : typeof submit !== "undefined" ? submit : undefined);
    if (tags.length === 1 && !Array.isArray(tags[0])) {
      return tags.pop();
    }
    tags.unshift("div", null);
    return React.createElement.apply(React, tags);
  };
  
  fn.locals = function setLocals(locals) {
    var render = this;
    function newRender(additionalLocals) {
      var newLocals = {};
      for (var key in locals) {
        newLocals[key] = locals[key];
      }
      if (additionalLocals) {
        for (var key in additionalLocals) {
          newLocals[key] = additionalLocals[key];
        }
      }
      return render.call(this, newLocals);
    }
    newRender.locals = setLocals;
    return newRender;
  };;
  return fn;
}(React))