root = @
root.expect = chai.expect

root.beforeEach ->
  root.$$ = $('<div class="fixture"/>').appendTo('body')

root.afterEach ->
  root.$$.remove()

root.fixture = (toInsert)->
  $fixture = $(toInsert).appendTo(root.$$)
  $fixture
