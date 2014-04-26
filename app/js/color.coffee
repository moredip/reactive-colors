createColor = ({red,green,blue})->
  tc = tinycolor({r:red,g:green,b:blue})
  tc.describe = -> {red,green,blue}
  tc

window.rc ||= {}
window.rc.createColor = createColor

