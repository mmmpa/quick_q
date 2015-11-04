module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(Fa, goHome) {
      tags.push(React.createElement("section", {
        className: "global-menu menu-area"
      }, React.createElement("div", {
        className: "global-menu menu-body"
      }, React.createElement("button", {
        onClick: goHome,
        className: "global-menu go-home"
      }, React.createElement(Fa, {
        icon: "home",
        scale: 2
      })))));
    }).call(this, "Fa" in locals_for_with ? locals_for_with.Fa : typeof Fa !== "undefined" ? Fa : undefined, "goHome" in locals_for_with ? locals_for_with.goHome : typeof goHome !== "undefined" ? goHome : undefined);
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