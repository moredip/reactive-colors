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
