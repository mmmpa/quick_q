module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(Fa, Object, isFalse, isTrue, toggle) {
      function jade_join_classes(val) {
        return (Array.isArray(val) ? val.map(jade_join_classes) : val && "object" == typeof val ? Object.keys(val).filter(function(key) {
          return val[key];
        }) : [ val ]).filter(function(val) {
          return null != val && "" !== val;
        }).join(" ");
      }
      tags.push(React.createElement("section", {
        className: "question-q ox-control"
      }, React.createElement("div", {
        onClick: toggle.bind(null, 1),
        className: jade_join_classes([ "question-q", "ox-button", "o", isTrue() ])
      }, React.createElement(Fa, {
        icon: "circle-o"
      })), React.createElement("div", {
        onClick: toggle.bind(null, 0),
        className: jade_join_classes([ "question-q", "ox-button", "x", isFalse() ])
      }, React.createElement(Fa, {
        icon: "times"
      }))));
    }).call(this, "Fa" in locals_for_with ? locals_for_with.Fa : typeof Fa !== "undefined" ? Fa : undefined, "Object" in locals_for_with ? locals_for_with.Object : typeof Object !== "undefined" ? Object : undefined, "isFalse" in locals_for_with ? locals_for_with.isFalse : typeof isFalse !== "undefined" ? isFalse : undefined, "isTrue" in locals_for_with ? locals_for_with.isTrue : typeof isTrue !== "undefined" ? isTrue : undefined, "toggle" in locals_for_with ? locals_for_with.toggle : typeof toggle !== "undefined" ? toggle : undefined);
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