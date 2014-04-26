inputStreamFrom = ($input)->
  $input.asEventStream('input')
    .map( (e)-> $(e.target).val() )
    .toProperty( $input.val() )
    .map( parseInt )

updateSwatch = ($swatch,color)->
  hashHex = "#"+color.toHex()
  $swatch
    .css( "background-color", hashHex )
    .text(hashHex)

$ ->
  $swatch = $("#swatch")

  sliderStreams = {
    red: inputStreamFrom( $('.red input') )
    green: inputStreamFrom( $('.green input') )
    blue: inputStreamFrom( $('.blue input') )
  }

  for name,stream of sliderStreams
    stream.assign($(".#{name} .number"), "text")

  slidersColorStream = Bacon.combineTemplate( sliderStreams ).map( rc.createColor )
  slidersColorStream.onValue (color)-> 
    console.log( "color changed", color.describe() )
    updateSwatch($swatch,color)



