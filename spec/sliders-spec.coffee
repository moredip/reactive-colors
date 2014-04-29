describe 'sliders', ->
  $slider = undefined
  $label = undefined
  beforeEach ->
    $slider = fixture('<input type="range" min="0" max="100"/>')
    $label = fixture('<div/>')

  updateSliderVal = (val)->
    $slider.val(val).trigger("input")

  it 'updates a label when the slider changes', ->
    # Given
    window.rc.wireUp( {$slider,$label} )
    
    # When
    updateSliderVal("20")
    
    # Then
    expect($label.text()).equal("20")

  it 'sets an initial label', ->
    # Given
    $slider.val("55")

    # When
    window.rc.wireUp( {$slider,$label} )

    # Then
    expect($label.text()).equal("55")
