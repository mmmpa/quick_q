module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(Fa, isActive, isCorrect, isMarked, options, toggle) {
      tags.push(React.createElement("ul", {
        className: "question-q options"
      }, function() {
        var tags = [];
        var $$obj = options;
        if ("number" == typeof $$obj.length) for (var index = 0, $$l = $$obj.length; $$l > index; index++) {
          var option = $$obj[index];
          tags.push(React.createElement("li", {
            onClick: toggle.bind(null, option.id),
            key: option.id,
            className: "question-q option"
          }, React.createElement.apply(React, [ "div", {
            className: "question-q checker"
          } ].concat(function() {
            var tags = [];
            isMarked() && (isCorrect(option.id) ? tags.push(React.createElement("span", {
              className: "question-q mark-on-check correct"
            }, React.createElement(Fa, {
              icon: "circle-o"
            }))) : tags.push(React.createElement("span", {
              className: "question-q mark-on-check incorrect"
            }, React.createElement(Fa, {
              icon: "times"
            }))));
            isActive(option.id) ? tags.push(React.createElement("span", {
              className: "question-q check active"
            }, React.createElement(Fa, {
              icon: "check",
              scale: 2
            }))) : tags.push(React.createElement("span", {
              className: "question-q check"
            }, React.createElement(Fa, {
              icon: "check",
              scale: 2
            })));
            return tags;
          }.call(this))), React.createElement("div", {
            dangerouslySetInnerHTML: option.marked,
            className: "question-q a-text"
          })));
        } else {
          var $$l = 0;
          for (var index in $$obj) {
            $$l++;
            var option = $$obj[index];
            tags.push(React.createElement("li", {
              onClick: toggle.bind(null, option.id),
              key: option.id,
              className: "question-q option"
            }, React.createElement.apply(React, [ "div", {
              className: "question-q checker"
            } ].concat(function() {
              var tags = [];
              isMarked() && (isCorrect(option.id) ? tags.push(React.createElement("span", {
                className: "question-q mark-on-check correct"
              }, React.createElement(Fa, {
                icon: "circle-o"
              }))) : tags.push(React.createElement("span", {
                className: "question-q mark-on-check incorrect"
              }, React.createElement(Fa, {
                icon: "times"
              }))));
              isActive(option.id) ? tags.push(React.createElement("span", {
                className: "question-q check active"
              }, React.createElement(Fa, {
                icon: "check",
                scale: 2
              }))) : tags.push(React.createElement("span", {
                className: "question-q check"
              }, React.createElement(Fa, {
                icon: "check",
                scale: 2
              })));
              return tags;
            }.call(this))), React.createElement("div", {
              dangerouslySetInnerHTML: option.marked,
              className: "question-q a-text"
            })));
          }
        }
        return tags;
      }.call(this)));
    }).call(this, "Fa" in locals_for_with ? locals_for_with.Fa : typeof Fa !== "undefined" ? Fa : undefined, "isActive" in locals_for_with ? locals_for_with.isActive : typeof isActive !== "undefined" ? isActive : undefined, "isCorrect" in locals_for_with ? locals_for_with.isCorrect : typeof isCorrect !== "undefined" ? isCorrect : undefined, "isMarked" in locals_for_with ? locals_for_with.isMarked : typeof isMarked !== "undefined" ? isMarked : undefined, "options" in locals_for_with ? locals_for_with.options : typeof options !== "undefined" ? options : undefined, "toggle" in locals_for_with ? locals_for_with.toggle : typeof toggle !== "undefined" ? toggle : undefined);
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