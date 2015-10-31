module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(input, isMarked) {
      tags.push(React.createElement("div", {
        className: "question-q text"
      }, React.createElement("input", {
        placeholder: "入力欄",
        disabled: isMarked(),
        onChange: input,
        className: "question-q free-text"
      })));
    }).call(this, "input" in locals_for_with ? locals_for_with.input : typeof input !== "undefined" ? input : undefined, "isMarked" in locals_for_with ? locals_for_with.isMarked : typeof isMarked !== "undefined" ? isMarked : undefined);
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