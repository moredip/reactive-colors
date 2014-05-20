chai.Assertion.addMethod 'color', (expected)->
  actual = @_obj
  @assert(
    tinycolor.equals(actual,expected)
    , "expected #{actual} to be the color #{expected}"
    , "expected #{actual} to not be the color #{expected}"
    , expected
    , actual
  )
