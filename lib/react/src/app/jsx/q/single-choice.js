module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(Fa, Object, is_active, options, toggle) {
      function jade_join_classes(val) {
        return (Array.isArray(val) ? val.map(jade_join_classes) : val && "object" == typeof val ? Object.keys(val).filter(function(key) {
          return val[key];
        }) : [ val ]).filter(function(val) {
          return null != val && "" !== val;
        }).join(" ");
      }
      tags.push(React.createElement("ul", {
        className: "question-q options"
      }, function() {
        var tags = [];
        var $$obj = options;
        if ("number" == typeof $$obj.length) for (var index = 0, $$l = $$obj.length; $$l > index; index++) {
          var option = $$obj[index];
          tags.push(React.createElement("li", {
            onClick: toggle.bind(null, option.id),
            className: "question-q option"
          }, React.createElement("div", {
            className: "question-q checker"
          }, React.createElement("span", {
            className: jade_join_classes([ "question-q", "check", is_active(option.id) ])
          }, React.createElement(Fa, {
            icon: "check",
            scale: 2
          }))), React.createElement("div", {
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
              className: "question-q option"
            }, React.createElement("div", {
              className: "question-q checker"
            }, React.createElement("span", {
              className: jade_join_classes([ "question-q", "check", is_active(option.id) ])
            }, React.createElement(Fa, {
              icon: "check",
              scale: 2
            }))), React.createElement("div", {
              dangerouslySetInnerHTML: option.marked,
              className: "question-q a-text"
            })));
          }
        }
        return tags;
      }.call(this)));
    }).call(this, "Fa" in locals_for_with ? locals_for_with.Fa : typeof Fa !== "undefined" ? Fa : undefined, "Object" in locals_for_with ? locals_for_with.Object : typeof Object !== "undefined" ? Object : undefined, "is_active" in locals_for_with ? locals_for_with.is_active : typeof is_active !== "undefined" ? is_active : undefined, "options" in locals_for_with ? locals_for_with.options : typeof options !== "undefined" ? options : undefined, "toggle" in locals_for_with ? locals_for_with.toggle : typeof toggle !== "undefined" ? toggle : undefined);
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