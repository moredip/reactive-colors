# courtesy https://github.com/jashkenas/underscore/issues/220#issuecomment-23748217
_.mixin(
  mapValues: (obj, f_val)->
    _.object(_.keys(obj), _.map(obj, f_val))
)

