COMPONENTS = "red green blue hue saturation lightness".split(" ")

# from tinycolor
pad2 = (c)->
  if c.length == 1 then '0' + c else '' + c

# from tinycolor
decimalToHex = (d)->
  pad2( Math.round(d).toString(16) )


inputStreamFrom = ($input)->
  stream = $input.asEventStream('input')
    .map( (e)-> $(e.target).val() )
    .toProperty( $input.val() )
    .map( parseFloat )

  stream.onValue (v)->
    console.log( $input.parent().attr("class"), v )

  stream

updateSwatch = ($swatch,color)->
  hashHex = "#"+color.toHex()
  $swatch
    .css( "background-color", hashHex )
    .text(hashHex)

labelForRgbValue = (val)->
  ratio = val/255
  percentage = Math.round(ratio * 100)
  hex = decimalToHex(val)
  #"#{val}/255 | #{percentage}% | #{hex}"
  "#{percentage}%"

componentOutputStreamsFromMainStream = (colorStream)->
  rgbStream = colorStream.map( ".toRgb" )
  hslStream = colorStream.map( ".toHsl" )

  {
    red: rgbStream.map( ".r" )
    green: rgbStream.map( ".g" )
    blue: rgbStream.map( ".b" )
    hue: hslStream.map( ".h" )
    saturation: hslStream.map( ".s" )
    lightness: hslStream.map( ".l" )
  }

  
mainColorStreamFromInputSliders = ($sliders)->
  sliderStreams = _.object( _.map( $sliders, ($slider,name)->
    [name,inputStreamFrom($slider)]
  ))

  rgbSliderStreams = _.pick(sliderStreams,"red","green","blue")
  hslSliderStreams = _.pick(sliderStreams,"hue","saturation","lightness")

  rgbInputStream = Bacon.combineTemplate( rgbSliderStreams ).map ({red,green,blue})->
    tinycolor({r:red,g:green,b:blue})

  hslInputStream = Bacon.combineTemplate( hslSliderStreams ).map ({hue,saturation,lightness})->
    tinycolor({h:hue,s:saturation,l:lightness})
  
  colorStream = Bacon.mergeAll( [rgbInputStream.changes(), hslInputStream.changes()] )
  colorStream

$ ->
  $swatch = $("#swatch")

  $sliders = _.object( _.map( COMPONENTS, (name)->
    [name, $(".#{name} input")]
  ))

  $labels = _.object( _.map( COMPONENTS, (name)->
    [name, $(".#{name} .number")]
  ))

  sliderStreams = _.object( _.map( $sliders, ($slider,name)->
    [name,inputStreamFrom($slider)]
  ))

  colorStream = mainColorStreamFromInputSliders($sliders)

  colorStream.onValue (color)->
    console.log( "color changed", color.toRgbString(), color.toHslString() )
    updateSwatch( $swatch, color )

  componentOutputStreams = componentOutputStreamsFromMainStream( colorStream )

  for name,stream of componentOutputStreams
    stream.assign( $sliders[name], "val" )

  for component in ["red","green","blue"]
    componentOutputStreams[component].map( labelForRgbValue ).assign($labels[component], "text")

  componentOutputStreams.hue.map( Math.round ).assign($labels.hue, "text")
  componentOutputStreams.saturation.map( (f)-> f.toFixed(3) ).assign($labels.saturation, "text")
  componentOutputStreams.lightness.map( (f)-> f.toFixed(3) ).assign($labels.lightness, "text")





