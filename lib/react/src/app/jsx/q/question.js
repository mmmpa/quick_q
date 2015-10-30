module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(Fa, Object, SingleChoice, answers, is_active, question, submit) {
      function jade_join_classes(val) {
        return (Array.isArray(val) ? val.map(jade_join_classes) : val && "object" == typeof val ? Object.keys(val).filter(function(key) {
          return val[key];
        }) : [ val ]).filter(function(val) {
          return null != val && "" !== val;
        }).join(" ");
      }
      tags.push(React.createElement("section", {
        className: "question-q body"
      }, React.createElement("section", {
        className: "question-q text"
      }, React.createElement("h1", {
        className: "question-q q"
      }, React.createElement(Fa, {
        icon: "question-circle"
      }), "問題")), React.createElement("section", {
        className: "question-q question-area"
      }, React.createElement("div", {
        dangerouslySetInnerHTML: question.marked,
        className: "question-q q-text"
      })), React.createElement.apply(React, [ "section", {
        className: "question-q answer"
      } ].concat(function() {
        var tags = [];
        tags.push(React.createElement("h1", {
          className: "question-q a"
        }, React.createElement(Fa, {
          icon: "exclamation-circle"
        }), "答えは？"));
        tags.push(React.createElement("section", {
          className: "question-q answer-area"
        }));
        "free_text" == question.way || "ox" == question.way || ("single_choice" == question.way ? tags.push(React.createElement(SingleChoice, {
          options: question.options,
          answers: answers
        })) : "multiple_choices" == question.way || "in_order" == question.way);
        return tags;
      }.call(this))), React.createElement("section", {
        className: "question-q control"
      }, React.createElement("button", {
        onClick: submit,
        className: jade_join_classes([ "question-q", "button", "submit", is_active() ])
      }, React.createElement(Fa, {
        icon: "graduation-cap"
      }), " ", "正解を確認する"))));
    }).call(this, "Fa" in locals_for_with ? locals_for_with.Fa : typeof Fa !== "undefined" ? Fa : undefined, "Object" in locals_for_with ? locals_for_with.Object : typeof Object !== "undefined" ? Object : undefined, "SingleChoice" in locals_for_with ? locals_for_with.SingleChoice : typeof SingleChoice !== "undefined" ? SingleChoice : undefined, "answers" in locals_for_with ? locals_for_with.answers : typeof answers !== "undefined" ? answers : undefined, "is_active" in locals_for_with ? locals_for_with.is_active : typeof is_active !== "undefined" ? is_active : undefined, "question" in locals_for_with ? locals_for_with.question : typeof question !== "undefined" ? question : undefined, "submit" in locals_for_with ? locals_for_with.submit : typeof submit !== "undefined" ? submit : undefined);
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