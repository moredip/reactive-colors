window.rc ||= {}

window.rc.wireUp = ({$slider,$label})->
  propertyStream = $slider.asEventStream('input')
      .map( (e)-> $(e.target).val() )
      .toProperty( $slider.val() )

  propertyStream.assign( $label, "text" )
