inputStreamFrom = ($input)->
  $input.asEventStream('input').map( (e)-> $(e.target).val() )


$ ->
  sliderStreams = {
    red: inputStreamFrom( $('.red input') )
    green: inputStreamFrom( $('.green input') )
    blue: inputStreamFrom( $('.blue input') )
  }

  for name,stream of sliderStreams
    stream.onValue( (v) -> console.log( "#{name} changed", v ) )

    stream.assign($(".#{name} .number"), "text")


