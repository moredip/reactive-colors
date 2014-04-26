createColor = ({red,green,blue})->
  tc = tinycolor({r:red,g:green,b:blue})
  _.extend(tc, {
    describe: -> {red,green,blue}
    hue: -> @toHsl().h
    saturation: -> @toHsl().s
    lightness: -> @toHsl().l
  })

window.rc ||= {}
window.rc.createColor = createColor

