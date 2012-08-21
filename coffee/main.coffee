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

    objText += ";\n
var setKeyFrames = function($el, frames, duration) {\n
    var animate;\n
    animate = function() {\n
        var spendTime;\n
        spendTime = 0;\n
        $el.stop(true);\n
        $.each(frames, function(idx, val) {\n
            var stepDuration, stepPercentage;\n
            stepPercentage = idx.replace('%', '') / 100;\n
            stepDuration = duration * stepPercentage - spendTime;\n
            $el.animate(val, stepDuration);\n
            return spendTime += stepDuration;\n
        });\n
        return setTimeout(animate, duration);\n
    };\n
    return animate();\n
};\n
$(document).ready(function(){\n
    setKeyFrames($('.keyframes-fallback'), keyFrames.move, 2000);\n
});\n
    "

    $('#js').text(objText)
    console.log(KeyFrames)
    console.log(JSON.stringify(KeyFrames))



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





  $('#go').click( ->
    addCSSFile().done(->
      parseToJSObject()
    )
  )
  parseToJSObject()




)
