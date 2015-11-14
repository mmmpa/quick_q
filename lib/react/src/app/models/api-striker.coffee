#
# apiアクセス方法を統一するサービスクラス
# 一度アクセスしたapiのデータは保持する（GETのみ）
#
module.exports = class ApiStriker
  @_struck = {}

  @strike = (linker, forceReload)->
    console.log linker
    if !forceReload && linker.isGet && @_struck[linker.paramsUri]
      # Promiseを期待されるので空うちする。
      return new Promise((resolve, reject)=>
        resolve(@_struck[linker.paramsUri])
      )

    (if linker.isPost()
      $.ajax(
        url: '/api' + linker.uri
        type: linker.method
        dataType: 'json'
        contentType: 'application/json'
        data: JSON.stringify(linker.params)
      )
    else
      $.ajax(
        url: '/api' + linker.uri
        type: linker.method
        dataType: 'json'
        data: linker.params
      )
    ).then (data, __, xhr)=>
      # データ保持動作
      header = @pickHeaderParameters(xhr)
      if linker.isGet
        @_struck[linker.paramsUri] =
          body: data
          header: header
      $.Deferred().resolve(
        body: data
        header: header
      )

  @pickHeaderParameters: (xhr)->
    header = {}
    required = [
      'Total-Pages'
      'Per-Page'
      'Current-Page'
    ]
    names = [
      'total'
      'per'
      'page'
    ]
    _.each(required, (value, index)=>
      header[names[index]] = xhr.getResponseHeader(value)
    )

    header
