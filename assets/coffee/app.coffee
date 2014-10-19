class Square
  colors = [
    'orange',
    'green',
    'red',
    'blue',
    'violet',
    'yellow',
  ]
  constructor: (@game, @node)->
    @node.on 'click', =>
      @game.flood(@color)

  reset: ->
    @controlled = false
    color = colors[Math.floor(Math.random() * colors.length)]
    @setColor(color)

  setColor: (color)->
    @node.removeClass(@color)
    @color = color
    @node.addClass(@color)


class Game
  DIMENSION = 14
  SIZE = DIMENSION * DIMENSION
  constructor: ($tbody)->
    @limit = 25
    @grid = []
    for i in [0...DIMENSION]
      $tr = $ '<tr/>'
      $tbody.append $tr
      @grid.push []
      for j in [0...DIMENSION]
        $td = $('<td/>').html('&nbsp;')
        $tr.append $td
        @grid[i].push(new Square(@, $td))
    @top = @grid[0][0]
    @reset()

  reset: ->
    for i in [0...DIMENSION]
      for j in [0...DIMENSION]
        @grid[i][j].reset()
    @top = @grid[0][0]
    @top.controlled = true
    @flood(@top.color)
    @setTurnCounter(0)

  setTurnCounter: (counter)->
    $counter = $ '#count'
    @turn = counter
    $counter.toggleClass 'bad', @turn > @limit
    $('#counter-used').text(@turn)


  flood: (color)->
    if @top.color is color
      return
    @setTurnCounter(@turn + 1)
    @_flood(0, 0, color, [])
    if @hasWon()
      setTimeout(
        =>
          @decreaseLimit()
          @reset()
        2000
      )
  decreaseLimit: ()->
    @expected--



  _flood: (i, j, color, checked)->
    if i < 0 or j < 0 or i == DIMENSION or j == DIMENSION
      return
    cur = @grid[i][j]
    if cur.controlled or cur.color is color
      if cur in checked
        return
      cur.setColor(color)
      cur.controlled = true
      checked.push cur
      @_flood(i-1, j, color, checked)
      @_flood(i+1, j, color, checked)
      @_flood(i, j-1, color, checked)
      @_flood(i, j+1, color, checked)

  hasWon: ->
    for i in [0...DIMENSION]
      for j in [0...DIMENSION]
        if not @grid[i][j].controlled
          return false
    return true

(($, Game)->
  tbody = $('tbody')
  game = new Game(tbody)
  btnRestart = $('#btn-restart')
  btnRestart.on 'click', (e)->
    e.preventDefault()
    game.reset()

)(jQuery, Game)
