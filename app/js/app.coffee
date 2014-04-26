# from tinycolor
pad2 = (c)->
  if c.length == 1 then '0' + c else '' + c
decimalToHex = (d)->
  pad2( Math.round(d).toString(16) )

inputStreamFrom = ($input)->
  $input.asEventStream('input')
    .map( (e)-> $(e.target).val() )
    .toProperty( $input.val() )
    .map( parseFloat )

updateSwatch = ($swatch,color)->
  hashHex = "#"+color.toHex()
  $swatch
    .css( "background-color", hashHex )
    .text(hashHex)

labelForColorValue = (val)->
  ratio = val/255
  percentage = Math.round(ratio * 100)
  hex = decimalToHex(val)
  "#{val}/255 | #{percentage}% | #{hex}"
  "#{percentage}%"
  

$ ->
  $swatch = $("#swatch")
  $sliders = {
    hue: $('.hue input')
    saturation: $('.saturation input')
    lightness: $('.lightness input')
  }

  rgbStreams = {
    red: inputStreamFrom( $('.red input') )
    green: inputStreamFrom( $('.green input') )
    blue: inputStreamFrom( $('.blue input') )
  }

  for name,stream of rgbStreams
    stream
      .map( labelForColorValue )
      .assign($(".#{name} .number"), "text")

  slidersColorStream = Bacon.combineTemplate( rgbStreams ).map( rc.createColor )
  slidersColorStream.onValue (color)-> 
    console.log( "color changed", color.describe() )
    updateSwatch($swatch,color)

  hueStream = slidersColorStream.map( (color)-> color.hue() )
  saturationStream = slidersColorStream.map( (color)-> color.saturation() )
  lightnessStream = slidersColorStream.map( (color)-> color.lightness() )

  hueStream.assign( $sliders.hue, "val" )
  saturationStream.assign( $sliders.saturation, "val" )
  lightnessStream.assign( $sliders.lightness, "val" )





