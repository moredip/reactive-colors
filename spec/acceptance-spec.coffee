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
    updateSliderVal( $sliders.red, "126" )
    updateSliderVal( $sliders.green, "63" )
    updateSliderVal( $sliders.blue, "255" )

    # Then
    actualColor = tinycolor($label.css('background-color'))
    expectedColor =  tinycolor("rgb( 126, 63, 255)").toRgbString() 
    expect(actualColor.toRgbString()).equal(expectedColor)

  it 'does an initial update', ->
    # Given 
    updateSliderVal( $sliders.red, "53" )
    updateSliderVal( $sliders.green, "21" )
    updateSliderVal( $sliders.blue, "87" )

    # When
    window.rc.wireUpRgbSliders( {$sliders,$label} )

    # Then
    expect($label.text()).equal( "red: 53 green: 21 blue: 87" )
