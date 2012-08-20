define [
  'module'
], (module)->

  keyframes =
    set: ($el, frames, duration)->

      animate = ->
        spendTime = 0
        $el.stop(true)
        $.each(frames, (idx, val)->
          stepPercentage = idx.replace('%', '') / 100
          stepDuration = duration * stepPercentage - spendTime
          $el.animate(val, stepDuration)
          spendTime += stepDuration
        )
        setTimeout(animate, duration )
      animate()



  keyframes
