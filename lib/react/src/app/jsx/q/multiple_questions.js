module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(Fa, FreeText, InOrder, MultipleChoices, Ox, SingleChoice, answers, children, result) {
      tags.push(function() {
        var tags = [];
        var $$obj = children;
        if ("number" == typeof $$obj.length) for (var $index = 0, $$l = $$obj.length; $$l > $index; $index++) {
          var child = $$obj[$index];
          tags.push(React.createElement("section", {
            className: "question-q text"
          }, React.createElement("h1", {
            className: "question-q q"
          }, React.createElement(Fa, {
            icon: "question"
          }), "設問", child.index + 1)));
          tags.push(React.createElement("section", {
            className: "question-q question-area"
          }, React.createElement("div", {
            dangerouslySetInnerHTML: child.marked,
            className: "question-q q-text"
          })));
          tags.push(React.createElement("section", {
            className: "question-q answer"
          }, React.createElement("h1", {
            className: "question-q a"
          }, React.createElement(Fa, {
            icon: "exclamation"
          }), child.pleaseText)));
          child.isFreeText() ? tags.push(React.createElement(FreeText, {
            question: child,
            options: child.options,
            answers: answers[child.index],
            result: result[child.index]
          })) : child.isOx() ? tags.push(React.createElement(Ox, {
            question: child,
            options: child.options,
            answers: answers[child.index],
            result: result[child.index]
          })) : child.isSingleChoice() ? tags.push(React.createElement(SingleChoice, {
            question: child,
            options: child.options,
            answers: answers[child.index],
            result: result[child.index]
          })) : child.isMultipleChoices() ? tags.push(React.createElement(MultipleChoices, {
            question: child,
            options: child.options,
            answers: answers[child.index],
            result: result[child.index]
          })) : child.isInOrder() && tags.push(React.createElement(InOrder, {
            question: child,
            answers: answers[child.index],
            result: result[child.index]
          }));
        } else {
          var $$l = 0;
          for (var $index in $$obj) {
            $$l++;
            var child = $$obj[$index];
            tags.push(React.createElement("section", {
              className: "question-q text"
            }, React.createElement("h1", {
              className: "question-q q"
            }, React.createElement(Fa, {
              icon: "question"
            }), "設問", child.index + 1)));
            tags.push(React.createElement("section", {
              className: "question-q question-area"
            }, React.createElement("div", {
              dangerouslySetInnerHTML: child.marked,
              className: "question-q q-text"
            })));
            tags.push(React.createElement("section", {
              className: "question-q answer"
            }, React.createElement("h1", {
              className: "question-q a"
            }, React.createElement(Fa, {
              icon: "exclamation"
            }), child.pleaseText)));
            child.isFreeText() ? tags.push(React.createElement(FreeText, {
              question: child,
              options: child.options,
              answers: answers[child.index],
              result: result[child.index]
            })) : child.isOx() ? tags.push(React.createElement(Ox, {
              question: child,
              options: child.options,
              answers: answers[child.index],
              result: result[child.index]
            })) : child.isSingleChoice() ? tags.push(React.createElement(SingleChoice, {
              question: child,
              options: child.options,
              answers: answers[child.index],
              result: result[child.index]
            })) : child.isMultipleChoices() ? tags.push(React.createElement(MultipleChoices, {
              question: child,
              options: child.options,
              answers: answers[child.index],
              result: result[child.index]
            })) : child.isInOrder() && tags.push(React.createElement(InOrder, {
              question: child,
              answers: answers[child.index],
              result: result[child.index]
            }));
          }
        }
        return tags;
      }.call(this));
    }).call(this, "Fa" in locals_for_with ? locals_for_with.Fa : typeof Fa !== "undefined" ? Fa : undefined, "FreeText" in locals_for_with ? locals_for_with.FreeText : typeof FreeText !== "undefined" ? FreeText : undefined, "InOrder" in locals_for_with ? locals_for_with.InOrder : typeof InOrder !== "undefined" ? InOrder : undefined, "MultipleChoices" in locals_for_with ? locals_for_with.MultipleChoices : typeof MultipleChoices !== "undefined" ? MultipleChoices : undefined, "Ox" in locals_for_with ? locals_for_with.Ox : typeof Ox !== "undefined" ? Ox : undefined, "SingleChoice" in locals_for_with ? locals_for_with.SingleChoice : typeof SingleChoice !== "undefined" ? SingleChoice : undefined, "answers" in locals_for_with ? locals_for_with.answers : typeof answers !== "undefined" ? answers : undefined, "children" in locals_for_with ? locals_for_with.children : typeof children !== "undefined" ? children : undefined, "result" in locals_for_with ? locals_for_with.result : typeof result !== "undefined" ? result : undefined);
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