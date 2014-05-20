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

describe 'rgb sliders', ->
  $sliders = undefined
  beforeEach ->
    $sliders = {
      red: $('<input type="range" min="0" max="255"/>')
      green: $('<input type="range" min="0" max="255"/>')
      blue: $('<input type="range" min="0" max="255"/>')
    }

  collectEventsFrom = (stream)->
    events = []
    stream.onValue (v)->
      events.push(v)
    events

  it 'creates a stream with an initial event plus an event each time a slider changes', ->
    # Given
    updateSliderVal( $sliders.red, '35' )
    updateSliderVal( $sliders.green, '135' )
    updateSliderVal( $sliders.blue, '43' )

    # When
    stream = window.rc.createColorStreamForRgbSliders($sliders)
    events = collectEventsFrom(stream)

    updateSliderVal( $sliders.red, '100' )
    updateSliderVal( $sliders.blue, '88' )

    # Then
    expect(events.length).equal(3)
    expect(events[0]).color("rgb(35,135,43)")
    expect(events[1]).color("rgb(100,135,43)")
    expect(events[2]).color("rgb(100,135,88)")
