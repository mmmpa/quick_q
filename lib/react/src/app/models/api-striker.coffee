#
# 一度アクセスしたapiのデータは保持する（GETのみ）
#
module.exports = class ApiStriker
  @_struck = {}

  @strike = (linker, forceReload)->
    if !forceReload && linker.is_get && @_struck[linker.key]
      # Promiceを期待されるので空うちする。
      return new Promise((resolve, reject)=>
        resolve(@_struck[linker.key])
      )

    $.ajax(
      url: '/api' + linker.uri
      type: linker.method
      dataType: 'json'
      data: linker.params
    ).then((data)=>
      # データ保持動作
      @_struck[linker.key] = data if linker.is_get
    )
