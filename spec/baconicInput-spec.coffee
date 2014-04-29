describe 'e2e: ', ->
  describe 'baconic range input', ->
    $input = undefined
    baconicInput = undefined

    beforeEach ->
      $input = fixture('<input type="range" min="0" max="100" value="22"/>')
      baconicInput = window.rc.createBaconicInput( $input )

    it "has an initial property", ->
      # Given
      streamSpy = new sinon.spy()
      baconicInput.asProperty().onValue( streamSpy )

      # Then
      expect(streamSpy).calledWith(22)

    it 'streams changes to input value', ->
      # Given
      streamSpy = new sinon.spy()
      baconicInput.asProperty().onValue( streamSpy )

      # When
      $input.val('55').trigger("input")

      # Then
      expect(streamSpy).calledWith(55)
