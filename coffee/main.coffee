require([
  'module'
  './keyframes'
], (module, KeyFrames)->

  appendCSSID = "appendCSS"
  styleSheets = document.styleSheets

  cssObjects = {}

  addRule = (cssRules)->
    cssObj = {}
    for idx of cssRules
      if +idx >=0
        cssRule = cssRules[idx]
        keyText = cssRule.keyText
        style = cssRule.style
        setStyle = {}
        for st in style
          setStyle[st] = style[st]

        cssObj[keyText] = setStyle

    cssObjects[cssRules.name] = cssObj
    objText = JSON.stringify(cssObjects)

    objText = 'var keyFrames = \n' + objText
    $('#js').text(objText)

    initialTest(cssObjects)


  writeCSS = (styleSheets)->
    text = []
    for cssRules in styleSheets.cssRules
      text.push(cssRules.cssText)
    $('#css').text(text.join('\n'))






  addCSSFile = ()->
    _dfr = $.Deferred()
    window.URL = window.URL or window.webkitURL
    cssText = $('#css').val()
    blob = new Blob([cssText],
      type: "text/css"
    )
    $("##{appendCSSID}").remove()
    link = document.createElement("link")
    link.rel = "stylesheet"
    link.id = appendCSSID
    link.onload = ->
      _dfr.resolve()
    link.href = window.URL.createObjectURL(blob)
    document.body.appendChild link
    cssLink = window.URL.createObjectURL(blob)
    _dfr


  parseToJSObject = ->
    for CSSSTyleSheet in styleSheets
      if CSSSTyleSheet.ownerNode and CSSSTyleSheet.ownerNode.id is appendCSSID
        writeCSS(CSSSTyleSheet)
        for cssRules in CSSSTyleSheet.cssRules
          if cssRules.type is 7
            addRule(cssRules)

  initialTest = (keyFrames)->
    KeyFrames.set($('.keyframes-fallback'), keyFrames.move, 2000);




  $('#go').click( ->
    addCSSFile().done(->
      parseToJSObject()
    )
  )
  parseToJSObject()




)
