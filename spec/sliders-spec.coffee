updateSliderVal = ($slider,val)->
  $slider.val(val).trigger("input")

describe 'single slider', ->
  $slider = undefined
  $label = undefined
  beforeEach ->
    $slider = $('<input type="range" min="0" max="100"/>')
    $label = $('<div/>')

  it 'updates a label when the slider changes', ->
    # Given
    window.rc.wireUpSingleSlider( {$slider,$label} )
    
    # When
    updateSliderVal($slider,"20")
    
    # Then
    expect($label.text()).equal("20")

  it 'sets an initial label', ->
    # Given
    $slider.val("55")

    # When
    window.rc.wireUpSingleSlider( {$slider,$label} )

    # Then
    expect($label.text()).equal("55")

describe 'multiple sliders', ->
  $sliders = undefined
  $label = undefined

  beforeEach ->
    $sliders = {
      red: $('<input type="range" min="0" max="255"/>')
      green: $('<input type="range" min="0" max="255"/>')
      blue: $('<input type="range" min="0" max="255"/>')
    }
    $label = fixture('<div/>')

  it 'updates a combined label', ->
    # Given 
    window.rc.wireUpRgbSliders( {$sliders,$label} )

    # When
    updateSliderVal( $sliders.red, "10" )
    updateSliderVal( $sliders.green, "20" )
    updateSliderVal( $sliders.blue, "30" )

    # Then
    expect($label.text()).equal( "red: 10 green: 20 blue: 30" )

  it 'updates a background color', ->
    # Given 
    window.rc.wireUpRgbSliders( {$sliders,$label} )

    # When
    updateSliderVal( $sliders.red, "127" )
    updateSliderVal( $sliders.green, "63" )
    updateSliderVal( $sliders.blue, "255" )

    # Then
    expect($label.style('background-color')).equal( "#aabbcc" )
