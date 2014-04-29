describe 'e2e: ', ->
  $fixture = -> $('body > .fixture')
  
  beforeEach ->
    $('body').append('<div class="fixture"/>')

  afterEach ->
    $fixture().remove()

  describe 'baconic range input', ->
    $input = undefined
    baconicInput = undefined

    beforeEach ->
      $input = $('<input type="range" min="0" max="100" value="22"/>').appendTo($fixture())
      baconicInput = window.rc.createBaconicInput( $input )

    it "has an initial property", ->
      # Given
      streamSpy = new sinon.spy()
      baconicInput.asProperty().onValue( streamSpy )

      # Then
      expect(streamSpy).toHaveBeenCalledWith(22)

    it 'streams changes to input value', ->
      # Given
      streamSpy = new sinon.spy()
      baconicInput.asProperty().onValue( streamSpy )

      # When
      $input.val('55').trigger("input")

      # Then
      expect(streamSpy).toHaveBeenCalledWith(55)
