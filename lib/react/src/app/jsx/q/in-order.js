module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(Fa, answersNumber, isCorrect, isMarked, options, select) {
      var n = 0;
      for (;n < answersNumber; ) {
        tags.push(React.createElement("section", {}, React.createElement.apply(React, [ "div", {
          className: "question-q order number"
        } ].concat(function() {
          var tags = [];
          isMarked() && (isCorrect(n) ? tags.push(React.createElement("span", {
            className: "question-q mark-on-check correct"
          }, React.createElement(Fa, {
            icon: "circle-o"
          }))) : tags.push(React.createElement("span", {
            className: "question-q mark-on-check incorrect"
          }, React.createElement(Fa, {
            icon: "times"
          }))));
          tags.push(React.createElement("span", {
            className: "number-circle"
          }, n + 1));
          return tags;
        }.call(this))), React.createElement("div", {
          className: "question-q order select"
        }, React.createElement("select", {
          onChange: select,
          name: n,
          disabled: isMarked(),
          className: "question-q order selector"
        }, React.createElement("option", {
          value: ""
        }, "未選択"), function() {
          var tags = [];
          var $$obj = options;
          if ("number" == typeof $$obj.length) for (var index = 0, $$l = $$obj.length; $$l > index; index++) {
            var option = $$obj[index];
            tags.push(React.createElement("option", {
              dangerouslySetInnerHTML: option.marked,
              value: option.id
            }));
          } else {
            var $$l = 0;
            for (var index in $$obj) {
              $$l++;
              var option = $$obj[index];
              tags.push(React.createElement("option", {
                dangerouslySetInnerHTML: option.marked,
                value: option.id
              }));
            }
          }
          return tags;
        }.call(this)))));
        n++;
      }
    }).call(this, "Fa" in locals_for_with ? locals_for_with.Fa : typeof Fa !== "undefined" ? Fa : undefined, "answersNumber" in locals_for_with ? locals_for_with.answersNumber : typeof answersNumber !== "undefined" ? answersNumber : undefined, "isCorrect" in locals_for_with ? locals_for_with.isCorrect : typeof isCorrect !== "undefined" ? isCorrect : undefined, "isMarked" in locals_for_with ? locals_for_with.isMarked : typeof isMarked !== "undefined" ? isMarked : undefined, "options" in locals_for_with ? locals_for_with.options : typeof options !== "undefined" ? options : undefined, "select" in locals_for_with ? locals_for_with.select : typeof select !== "undefined" ? select : undefined);
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