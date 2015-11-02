module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(Paginator, header, index, showQuestion) {
      tags.push(React.createElement(Paginator, {
        header: header
      }));
      tags.push(React.createElement("section", {
        className: "question-index index"
      }, React.createElement("table", {
        className: "question-index list"
      }, React.createElement("tbody", {}, function() {
        var tags = [];
        var $$obj = index;
        if ("number" == typeof $$obj.length) for (var $index = 0, $$l = $$obj.length; $$l > $index; $index++) {
          var question = $$obj[$index];
          tags.push(React.createElement("tr", {
            key: question.id
          }, React.createElement("th", {
            className: "id"
          }, question.id), React.createElement("td", {
            className: "description"
          }, React.createElement("a", {
            onClick: showQuestion.bind(null, question),
            props: question
          }, question.description)), React.createElement("td", {
            className: "way"
          }, question.wayText)));
        } else {
          var $$l = 0;
          for (var $index in $$obj) {
            $$l++;
            var question = $$obj[$index];
            tags.push(React.createElement("tr", {
              key: question.id
            }, React.createElement("th", {
              className: "id"
            }, question.id), React.createElement("td", {
              className: "description"
            }, React.createElement("a", {
              onClick: showQuestion.bind(null, question),
              props: question
            }, question.description)), React.createElement("td", {
              className: "way"
            }, question.wayText)));
          }
        }
        return tags;
      }.call(this)))));
      tags.push(React.createElement(Paginator, {
        header: header
      }));
    }).call(this, "Paginator" in locals_for_with ? locals_for_with.Paginator : typeof Paginator !== "undefined" ? Paginator : undefined, "header" in locals_for_with ? locals_for_with.header : typeof header !== "undefined" ? header : undefined, "index" in locals_for_with ? locals_for_with.index : typeof index !== "undefined" ? index : undefined, "showQuestion" in locals_for_with ? locals_for_with.showQuestion : typeof showQuestion !== "undefined" ? showQuestion : undefined);
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