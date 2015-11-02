module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(links, paginate) {
      tags.push(React.createElement("section", {
        className: "question-index paginator area"
      }, React.createElement("ul", {
        className: "question-index paginator list"
      }, function() {
        var tags = [];
        var $$obj = links;
        if ("number" == typeof $$obj.length) for (var $index = 0, $$l = $$obj.length; $$l > $index; $index++) {
          var link = $$obj[$index];
          tags.push(React.createElement.apply(React, [ "li", {
            key: link.page,
            className: "question-index paginator body"
          } ].concat(function() {
            var tags = [];
            link.isCurrent ? tags.push(React.createElement("a", {
              onClick: paginate.bind(null, link.page),
              className: "question-index paginator anchor now"
            }, link.page)) : tags.push(React.createElement("a", {
              onClick: paginate.bind(null, link.page),
              className: "question-index paginator anchor ready"
            }, link.page));
            return tags;
          }.call(this))));
        } else {
          var $$l = 0;
          for (var $index in $$obj) {
            $$l++;
            var link = $$obj[$index];
            tags.push(React.createElement.apply(React, [ "li", {
              key: link.page,
              className: "question-index paginator body"
            } ].concat(function() {
              var tags = [];
              link.isCurrent ? tags.push(React.createElement("a", {
                onClick: paginate.bind(null, link.page),
                className: "question-index paginator anchor now"
              }, link.page)) : tags.push(React.createElement("a", {
                onClick: paginate.bind(null, link.page),
                className: "question-index paginator anchor ready"
              }, link.page));
              return tags;
            }.call(this))));
          }
        }
        return tags;
      }.call(this))));
    }).call(this, "links" in locals_for_with ? locals_for_with.links : typeof links !== "undefined" ? links : undefined, "paginate" in locals_for_with ? locals_for_with.paginate : typeof paginate !== "undefined" ? paginate : undefined);
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