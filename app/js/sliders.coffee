window.rc ||= {}

propertyStreamForSlider = ($slider)->
  $slider.asEventStream('input')
    .map( (e)-> $(e.target).val() )
    .toProperty( $slider.val() )

window.rc.wireUpSingleSlider = ({$slider,$label})->
  propertyStream = propertyStreamForSlider($slider)
  propertyStream.assign( $label, "text" )

window.rc.createColorStreamForRgbSliders = ($sliders)->
  propertyStreams = {
    red: propertyStreamForSlider($sliders.red)
    green: propertyStreamForSlider($sliders.green)
    blue: propertyStreamForSlider($sliders.blue)
  }

  combinedStream = Bacon.combineTemplate( propertyStreams )

  colorStream = combinedStream.map ({red,green,blue})->
    tinycolor( r:red,g:green,b:blue )

window.rc.wireUpRgbSliders = ({$sliders,$label})->
  colorStream = window.rc.createColorStreamForRgbSliders($sliders)

  colorStream
    .map( (tc)-> tc.toHexString() )
    .assign( $label, "css", "background-color" )

  formattedStream = colorStream.map (color)->
    color.toRgbString

  formattedStream.assign( $label, "text" )
