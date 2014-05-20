root = @

root.updateSliderVal = ($slider,val)->
  $slider.val(val).trigger("input")
