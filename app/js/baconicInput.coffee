window.rc ||= {}

window.rc.createBaconicInput = ($input)->
  propertyStream = $input.asEventStream('input')
      .map( (e)-> $(e.target).val() )
      .toProperty( $input.val() )
      .map( parseFloat )

  assignFromStream = (stream)->
    stream.assign( $input, "val" )

  asProperty = -> propertyStream

  asObjectifiedProperty = (key)->
    propertyStream.map (v)->
      _.object( [[key,v]] )

  { asProperty, asObjectifiedProperty, assignFromStream }
