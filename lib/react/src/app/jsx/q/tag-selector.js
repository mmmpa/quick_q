module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(Fa, closeSelector, isChecked, isOpen, openSelector, qTags, toggleTag) {
      tags.push(React.createElement.apply(React, [ "section", {
        className: "tag-selector tag-selector-body"
      } ].concat(function() {
        var tags = [];
        if (isOpen()) {
          tags.push(React.createElement("h1", {
            className: "tag-selector sub-title"
          }, React.createElement(Fa, {
            icon: "tags"
          }), "タグを選択"));
          tags.push(React.createElement("ul", {
            className: "tag-selector tag-list-body"
          }, function() {
            var tags = [];
            var $$obj = qTags;
            if ("number" == typeof $$obj.length) for (var $index = 0, $$l = $$obj.length; $$l > $index; $index++) {
              var tag = $$obj[$index];
              tag.has_question() && tags.push(React.createElement("li", {
                key: tag.id,
                className: "tag-selector tag-list-tag"
              }, React.createElement("label", {}, React.createElement("input", {
                type: "checkbox",
                checked: isChecked(tag.id),
                onChange: toggleTag.bind(null, tag.id)
              }), React.createElement("span", {
                className: "name"
              }, tag.display), React.createElement("span", {
                className: "count"
              }, tag.countText))));
            } else {
              var $$l = 0;
              for (var $index in $$obj) {
                $$l++;
                var tag = $$obj[$index];
                tag.has_question() && tags.push(React.createElement("li", {
                  key: tag.id,
                  className: "tag-selector tag-list-tag"
                }, React.createElement("label", {}, React.createElement("input", {
                  type: "checkbox",
                  checked: isChecked(tag.id),
                  onChange: toggleTag.bind(null, tag.id)
                }), React.createElement("span", {
                  className: "name"
                }, tag.display), React.createElement("span", {
                  className: "count"
                }, tag.countText))));
              }
            }
            return tags;
          }.call(this)));
          tags.push(React.createElement("button", {
            onClick: closeSelector,
            className: "tag-selector tag-selector-opner"
          }, React.createElement(Fa, {
            icon: "chevron-up"
          }), "閉じる"));
        } else {
          tags.push(React.createElement("h1", {
            className: "tag-selector sub-title"
          }, React.createElement(Fa, {
            icon: "tags"
          }), "選択中のタグ"));
          tags.push(React.createElement("ul", {
            className: "tag-selector tag-list-body"
          }, function() {
            var tags = [];
            var $$obj = qTags;
            if ("number" == typeof $$obj.length) for (var $index = 0, $$l = $$obj.length; $$l > $index; $index++) {
              var tag = $$obj[$index];
              tag.has_question() && isChecked(tag.id) && tags.push(React.createElement("li", {
                key: tag.id,
                className: "tag-selector tag-list-tag"
              }, React.createElement(Fa, {
                icon: "tag"
              }), React.createElement("span", {
                className: "name"
              }, tag.display)));
            } else {
              var $$l = 0;
              for (var $index in $$obj) {
                $$l++;
                var tag = $$obj[$index];
                tag.has_question() && isChecked(tag.id) && tags.push(React.createElement("li", {
                  key: tag.id,
                  className: "tag-selector tag-list-tag"
                }, React.createElement(Fa, {
                  icon: "tag"
                }), React.createElement("span", {
                  className: "name"
                }, tag.display)));
              }
            }
            return tags;
          }.call(this)));
          tags.push(React.createElement("button", {
            onClick: openSelector,
            className: "tag-selector tag-selector-opner"
          }, React.createElement(Fa, {
            icon: "chevron-down"
          }), "タグを編集する"));
        }
        return tags;
      }.call(this))));
    }).call(this, "Fa" in locals_for_with ? locals_for_with.Fa : typeof Fa !== "undefined" ? Fa : undefined, "closeSelector" in locals_for_with ? locals_for_with.closeSelector : typeof closeSelector !== "undefined" ? closeSelector : undefined, "isChecked" in locals_for_with ? locals_for_with.isChecked : typeof isChecked !== "undefined" ? isChecked : undefined, "isOpen" in locals_for_with ? locals_for_with.isOpen : typeof isOpen !== "undefined" ? isOpen : undefined, "openSelector" in locals_for_with ? locals_for_with.openSelector : typeof openSelector !== "undefined" ? openSelector : undefined, "qTags" in locals_for_with ? locals_for_with.qTags : typeof qTags !== "undefined" ? qTags : undefined, "toggleTag" in locals_for_with ? locals_for_with.toggleTag : typeof toggleTag !== "undefined" ? toggleTag : undefined);
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