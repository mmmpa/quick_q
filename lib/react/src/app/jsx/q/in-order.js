module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(options, select) {
      tags.push(function() {
        var tags = [];
        var $$obj = options;
        if ("number" == typeof $$obj.length) for (var index = 0, $$l = $$obj.length; $$l > index; index++) {
          $$obj[index];
          tags.push(React.createElement("section", {}, React.createElement("div", {
            className: "question-q order number"
          }, React.createElement("span", {}, index)), React.createElement("div", {
            className: "question-q order select"
          }, React.createElement("select", {
            onChange: select,
            name: index,
            className: "question-q order selector"
          }, React.createElement("option", {}, "未選択"), function() {
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
        } else {
          var $$l = 0;
          for (var index in $$obj) {
            $$l++;
            $$obj[index];
            tags.push(React.createElement("section", {}, React.createElement("div", {
              className: "question-q order number"
            }, React.createElement("span", {}, index)), React.createElement("div", {
              className: "question-q order select"
            }, React.createElement("select", {
              onChange: select,
              name: index,
              className: "question-q order selector"
            }, React.createElement("option", {}, "未選択"), function() {
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
          }
        }
        return tags;
      }.call(this));
    }).call(this, "options" in locals_for_with ? locals_for_with.options : typeof options !== "undefined" ? options : undefined, "select" in locals_for_with ? locals_for_with.select : typeof select !== "undefined" ? select : undefined);
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