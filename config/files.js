/* Exports a function which returns an object that overrides the default &
 *   plugin file patterns (used widely through the app configuration)
 *
 * To see the default definitions for Lineman's file paths and globs, see:
 *
 *   - https://github.com/linemanjs/lineman/blob/master/config/files.coffee
 */
module.exports = function(lineman) {
  //Override file patterns here
  return {
    js: {
      vendor: [
          "vendor/bower/jquery/dist/jquery.js",
          "vendor/bower/bacon/dist/bacon.js",
          "vendor/bower/tinycolor/tinycolor.js",
          "vendor/bower/underscore/underscore.js",

          "vendor/bower/sinonjs/sinon.js",
          "vendor/bower/jasmine-sinon/lib/jasmine-sinon.js"
        ]
    }

    // As an example, to override the file patterns for
    // the order in which to load third party JS libs:
    //
    // js: {
    //   vendor: [
    //     "vendor/js/underscore.js",
    //     "vendor/js/**/*.js"
    //   ]
    // }

  };
};
