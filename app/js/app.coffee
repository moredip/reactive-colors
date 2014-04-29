COMPONENTS = "red green blue hue saturation lightness".split(" ")

# from tinycolor
pad2 = (c)->
  if c.length == 1 then '0' + c else '' + c

# from tinycolor
decimalToHex = (d)->
  pad2( Math.round(d).toString(16) )

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

rgbInputStreamFromSliderStreams = (sliderStreams)->
  rgbSliderStreams = _.pick(sliderStreams,"red","green","blue")
  rgbEventStreams = (stream.changes() for name,stream of rgbSliderStreams)

  Bacon.mergeAll(rgbEventStreams).map ({red,green,blue})->
    {r:red,g:green,b:blue}

hslInputStreamFromSliderStreams = (sliderStreams)->
  hslSliderStreams = _.pick(sliderStreams,"hue","saturation","lightness")
  hslEventStreams = (stream.changes() for name,stream of hslSliderStreams)

  Bacon.mergeAll(hslEventStreams).map ({hue,saturation,lightness})->
    {h:hue,l:lightness,s:saturation}


masterColorStreamFromInputSliders = ($sliders)->
  masterColor = tinycolor("#aabbcc")
  masterColorBus = new Bacon.Bus()

  sliderStreams = _.object( _.map( $sliders, ($slider,name)->
    [name,$slider.asObjectifiedProperty(name)]
  ))

  rgbInputStream = rgbInputStreamFromSliderStreams(sliderStreams)
  hslInputStream = hslInputStreamFromSliderStreams(sliderStreams)

  rgbInputStream.onValue (rgb)->
    masterColor = tinycolor( _.defaults( rgb, masterColor.toRgb() ) )
    masterColorBus.push(masterColor)

  hslInputStream.onValue (hsl)->
    masterColor = tinycolor( _.defaults( hsl, masterColor.toHsl() ) )
    masterColorBus.push(masterColor)

  masterColorBus.toProperty(masterColor)

assignComponentOutputStreams = (componentOutputStreams, $sliders, $labels)->
  for name,stream of componentOutputStreams
    $sliders[name].assignFromStream(stream)

  for component in ["red","green","blue"]
    componentOutputStreams[component].map( labelForRgbValue ).assign($labels[component], "text")

  componentOutputStreams.hue.map( Math.round ).assign($labels.hue, "text")
  componentOutputStreams.saturation.map( (f)-> f.toFixed(3) ).assign($labels.saturation, "text")
  componentOutputStreams.lightness.map( (f)-> f.toFixed(3) ).assign($labels.lightness, "text")

$ ->
  $swatch = $("#swatch")

  $sliders = _.object( _.map( COMPONENTS, (name)->
    [name, window.rc.createBaconicInput( $(".#{name} input") )]
  ))

  $labels = _.object( _.map( COMPONENTS, (name)->
    [name, $(".#{name} .number")]
  ))

  colorStream = masterColorStreamFromInputSliders($sliders)

  colorStream.onValue (color)->
    console.log( "color changed", color.toRgbString(), color.toHslString() )
    updateSwatch( $swatch, color )

  componentOutputStreams = componentOutputStreamsFromMainStream( colorStream )
  assignComponentOutputStreams( componentOutputStreams, $sliders, $labels )

