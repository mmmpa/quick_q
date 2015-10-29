console.log 'loading app'

module.exports = App = {}


if window?
  window.App = App
else
  global.App = App


console.log 'loading module'


_.merge(App, require './models')

App.JSX = require './jsx/jsx'
App.Util = require './util'
App.View = require './views'
App.Lang = require './lang'
App.Path = require './path'
App.Constant = require './constant'

# contextsはクラスを直接参照するため、他のクラスの後に読み込む必要がある。
_.merge(App, require './contexts')

console.log 'loaded app', App

App.start = (node)->
  router = new Arda.Router(Arda.DefaultLayout, node)
  router.pushContext(App.MainContext)



