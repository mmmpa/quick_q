module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(Fa, QuestionState, SingleChoice, answers, question, result, state, submit) {
      tags.push(React.createElement.apply(React, [ "section", {
        className: "question-q body"
      } ].concat(function() {
        var tags = [];
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
        tags.push(React.createElement.apply(React, [ "section", {
          className: "question-q answer"
        } ].concat(function() {
          var tags = [];
          tags.push(React.createElement("h1", {
            className: "question-q a"
          }, React.createElement(Fa, {
            icon: "exclamation-circle"
          }), question.pleaseText));
          tags.push(React.createElement("section", {
            className: "question-q answer-area"
          }));
          "free_text" == question.way || "ox" == question.way || ("single_choice" == question.way ? tags.push(React.createElement(SingleChoice, {
            options: question.options,
            answers: answers,
            result: result
          })) : "multiple_choices" == question.way || "in_order" == question.way);
          return tags;
        }.call(this))));
        state == QuestionState.MARKED ? tags.push(React.createElement("section", {
          className: "question-q result-area"
        }, React.createElement.apply(React, [ "div", {
          className: "question-q mark-area"
        } ].concat(function() {
          var tags = [];
          result.is_correct() ? tags.push(React.createElement("h1", {
            className: "question-q mark correct"
          }, result.resultText)) : tags.push(React.createElement("h1", {
            className: "question-q mark incorrect"
          }, result.resultText));
          return tags;
        }.call(this))), React.createElement("h1", {
          className: "question-q correct-answer"
        }, React.createElement(Fa, {
          icon: "graduation-cap"
        }), "正解は..."), React.createElement("div", {
          dangerouslySetInnerHTML: result.correctAnswer,
          className: "question-q answer-area"
        }))) : tags.push(React.createElement.apply(React, [ "section", {
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
        return tags;
      }.call(this))));
    }).call(this, "Fa" in locals_for_with ? locals_for_with.Fa : typeof Fa !== "undefined" ? Fa : undefined, "QuestionState" in locals_for_with ? locals_for_with.QuestionState : typeof QuestionState !== "undefined" ? QuestionState : undefined, "SingleChoice" in locals_for_with ? locals_for_with.SingleChoice : typeof SingleChoice !== "undefined" ? SingleChoice : undefined, "answers" in locals_for_with ? locals_for_with.answers : typeof answers !== "undefined" ? answers : undefined, "question" in locals_for_with ? locals_for_with.question : typeof question !== "undefined" ? question : undefined, "result" in locals_for_with ? locals_for_with.result : typeof result !== "undefined" ? result : undefined, "state" in locals_for_with ? locals_for_with.state : typeof state !== "undefined" ? state : undefined, "submit" in locals_for_with ? locals_for_with.submit : typeof submit !== "undefined" ? submit : undefined);
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