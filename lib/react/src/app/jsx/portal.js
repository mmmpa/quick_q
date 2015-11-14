module.exports = (function (React) {
  var fn = function(locals) {
    var tags = [];
    var locals_for_with = locals || {};
    (function(Fa, Loading, isSourcesLoaded, isTagsLoaded, qTags, showTaggedIndex, sources) {
      tags.push(React.createElement("section", {
        className: "portal portal-body"
      }, React.createElement.apply(React, [ "section", {
        className: "portal tag-list area"
      } ].concat(function() {
        var tags = [];
        tags.push(React.createElement("h1", {
          className: "portal sub-title"
        }, React.createElement(Fa, {
          icon: "tags"
        }), "タグリスト"));
        isTagsLoaded() ? tags.push(React.createElement("ul", {
          className: "portal tag-list-body"
        }, function() {
          var tags = [];
          var $$obj = qTags;
          if ("number" == typeof $$obj.length) for (var $index = 0, $$l = $$obj.length; $$l > $index; $index++) {
            var tag = $$obj[$index];
            tag.hasQuestion() ? tags.push(React.createElement("li", {
              key: tag.id,
              className: "portal tag-list-tag"
            }, React.createElement(Fa, {
              icon: "tag"
            }), React.createElement("a", {
              href: tag.uri,
              rel: tag.id,
              onClick: showTaggedIndex
            }, React.createElement("span", {
              className: "name"
            }, tag.display), React.createElement("span", {
              className: "count"
            }, tag.countText)))) : tags.push(React.createElement("li", {
              key: tag.id,
              className: "portal tag-list-tag disabled"
            }, React.createElement(Fa, {
              icon: "tag"
            }), React.createElement("span", {}, React.createElement("span", {
              className: "name"
            }, tag.display), React.createElement("span", {
              className: "count"
            }, tag.countText))));
          } else {
            var $$l = 0;
            for (var $index in $$obj) {
              $$l++;
              var tag = $$obj[$index];
              tag.hasQuestion() ? tags.push(React.createElement("li", {
                key: tag.id,
                className: "portal tag-list-tag"
              }, React.createElement(Fa, {
                icon: "tag"
              }), React.createElement("a", {
                href: tag.uri,
                rel: tag.id,
                onClick: showTaggedIndex
              }, React.createElement("span", {
                className: "name"
              }, tag.display), React.createElement("span", {
                className: "count"
              }, tag.countText)))) : tags.push(React.createElement("li", {
                key: tag.id,
                className: "portal tag-list-tag disabled"
              }, React.createElement(Fa, {
                icon: "tag"
              }), React.createElement("span", {}, React.createElement("span", {
                className: "name"
              }, tag.display), React.createElement("span", {
                className: "count"
              }, tag.countText))));
            }
          }
          return tags;
        }.call(this))) : tags.push(React.createElement(Loading, {}));
        return tags;
      }.call(this))), React.createElement.apply(React, [ "section", {
        className: "portal source area"
      } ].concat(function() {
        var tags = [];
        tags.push(React.createElement("h1", {
          className: "portal sub-title"
        }, React.createElement(Fa, {
          icon: "link"
        }), "出典リスト（予定含む）"));
        isSourcesLoaded() ? tags.push(React.createElement("ul", {
          className: "portal source-list-body"
        }, function() {
          var tags = [];
          var $$obj = sources;
          if ("number" == typeof $$obj.length) for (var $index = 0, $$l = $$obj.length; $$l > $index; $index++) {
            var source = $$obj[$index];
            tags.push(React.createElement("li", {
              key: source.id,
              className: "portal source-list-source"
            }, React.createElement(Fa, {
              icon: "link"
            }), React.createElement("a", {
              href: source.url
            }, source.display)));
          } else {
            var $$l = 0;
            for (var $index in $$obj) {
              $$l++;
              var source = $$obj[$index];
              tags.push(React.createElement("li", {
                key: source.id,
                className: "portal source-list-source"
              }, React.createElement(Fa, {
                icon: "link"
              }), React.createElement("a", {
                href: source.url
              }, source.display)));
            }
          }
          return tags;
        }.call(this))) : tags.push(React.createElement(Loading, {}));
        return tags;
      }.call(this))), React.createElement("section", {
        className: "portal tag-list area"
      }, React.createElement("h1", {
        className: "portal sub-title"
      }, React.createElement(Fa, {
        icon: "bullhorn"
      }), "ところでこれはなに"), React.createElement("section", {
        className: "portal hello"
      }, React.createElement("p", {}, "おふくろさま（無職、36歳、男、", React.createElement("a", {
        href: "https://twitter.com/o296sm"
      }, "@o296sm"), "）がプログラムの勉強のためにつくっています。"), React.createElement("p", {}, "ソースは公開していますが、動作保証などはありません。", React.createElement("a", {
        href: "https://github.com/mmmpa/quick_q"
      }, "https://github.com/mmmpa/quick_q")), React.createElement("p", {}, "各問題は使用条件にしたがい、出典を明記していますので、そちらで最終確認することをおすすめします。"), React.createElement("p", {}, "本サイト、本サイトのソースの利用によって生じたいかなる損害に対してもおふくろさまは一切の責任を負わないものとします。")))));
    }).call(this, "Fa" in locals_for_with ? locals_for_with.Fa : typeof Fa !== "undefined" ? Fa : undefined, "Loading" in locals_for_with ? locals_for_with.Loading : typeof Loading !== "undefined" ? Loading : undefined, "isSourcesLoaded" in locals_for_with ? locals_for_with.isSourcesLoaded : typeof isSourcesLoaded !== "undefined" ? isSourcesLoaded : undefined, "isTagsLoaded" in locals_for_with ? locals_for_with.isTagsLoaded : typeof isTagsLoaded !== "undefined" ? isTagsLoaded : undefined, "qTags" in locals_for_with ? locals_for_with.qTags : typeof qTags !== "undefined" ? qTags : undefined, "showTaggedIndex" in locals_for_with ? locals_for_with.showTaggedIndex : typeof showTaggedIndex !== "undefined" ? showTaggedIndex : undefined, "sources" in locals_for_with ? locals_for_with.sources : typeof sources !== "undefined" ? sources : undefined);
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