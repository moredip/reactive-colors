window.rc ||= {}

window.rc.createBaconicInput = ($input)->
  property = $input.asEventStream('input')
      .map( (e)-> $(e.target).val() )
      .toProperty( $input.val() )

  assignFromStream = (stream)->
    stream.assign( $input, "val" )

  asObjectifiedProperty = (key)->
    property.map (v)->
      _.object( [[key,parseFloat(v)]] )

  { asObjectifiedProperty, assignFromStream }
