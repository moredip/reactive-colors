# from tinycolor
pad2 = (c)->
  if c.length == 1 then '0' + c else '' + c

decimalToHex = (d)->
  pad2( Math.round(d).toString(16) )

COMPONENTS = "red green blue hue saturation lightness".split(" ")


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

  $sliders = _.object( _.map( COMPONENTS, (name)->
    [name, $(".#{name} input")]
  ))

  sliderStreams = _.object( _.map( $sliders, ($slider,name)->
    [name,inputStreamFrom($slider)]
  ))

  rgbSliderStreams = _.pick(sliderStreams,"red","green","blue")
  hslSliderStreams = _.pick(sliderStreams,"hue","saturation","lightness")

  for name,stream of rgbSliderStreams
    stream
      .map( labelForColorValue )
      .assign($(".#{name} .number"), "text")

  rgbColorStream = Bacon.combineTemplate( rgbSliderStreams ).map ({red,green,blue})->
    tinycolor({r:red,g:green,b:blue})

  hslColorStream = Bacon.combineTemplate( hslSliderStreams ).map ({hue,saturation,lightness})->
    tinycolor({h:hue,s:saturation,l:lightness})
  
  #rgbColorStream.onValue (color)-> 
    #console.log( "rgb color changed", color )

  #hslColorStream.onValue (color)-> 
    #console.log( "hsl color changed", color )
    
  debugger

  colorStream = Bacon.mergeAll( [rgbColorStream.changes(), hslColorStream.changes()] )

  colorStream.onValue (color)->
    console.log( "color changed", color.toHexString() )
    updateSwatch( $swatch, color )

  hueStream = colorStream.map( (color)-> color.toHsl().h )
  saturationStream = colorStream.map( (color)-> color.toHsl().s )
  lightnessStream = colorStream.map( (color)-> color.toHsl().l )

  hueStream.assign( $sliders.hue, "val" )
  saturationStream.assign( $sliders.saturation, "val" )
  lightnessStream.assign( $sliders.lightness, "val" )

  hueStream.map( Math.round ).assign($(".hue .number"), "text")
  saturationStream.map( (f)-> f.toFixed(3) ).assign($(".saturation .number"), "text")
  lightnessStream.map( (f)-> f.toFixed(3) ).assign($(".lightness .number"), "text")





