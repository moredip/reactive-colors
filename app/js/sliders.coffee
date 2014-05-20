window.rc ||= {}

propertyStreamForSlider = ($slider)->
  $slider.asEventStream('input')
    .map( (e)-> $(e.target).val() )
    .toProperty( $slider.val() )

window.rc.wireUpSingleSlider = ({$slider,$label})->
  propertyStream = propertyStreamForSlider($slider)
  propertyStream.assign( $label, "text" )

window.rc.wireUpRgbSliders = ({$sliders,$label})->
  propertyStreams = {
    red: propertyStreamForSlider($sliders.red)
    green: propertyStreamForSlider($sliders.green)
    blue: propertyStreamForSlider($sliders.blue)
  }

  combinedStream = Bacon.combineTemplate( propertyStreams )

  colorStream = combinedStream.map ({red,green,blue})->
    tinycolor( r:red,g:green,b:blue )

  colorStream
    .map( (tc)-> tc.toHexString() )
    .assign( $label, "css", "background-color" )

  formattedStream = combinedStream.map ({red,green,blue})->
    "red: #{red} green: #{green} blue: #{blue}"

  formattedStream.assign( $label, "text" )
