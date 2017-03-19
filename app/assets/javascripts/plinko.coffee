$ ->
  bodies = []

  class Chip
    constructor: (@gate) ->

    jitter: ->
      Math.floor(Math.random() * 20) - 10
    body: ->
      console.log(@)
      console.log(@jitter())
      Matter.Bodies.circle(
        80.5 + ((@gate - 1) * 60) + @jitter(),
        20,
        22,
        friction: 0.001,
        restitution: 0.75,
        render: { strokeStyle: 'red', fillStyle: 'red' }
      )

  placePegs = ->
    x = undefined
    y = 20
    cols = undefined
    offset = undefined
    i = 0
    while i < 13
      y = y + 50
      if i % 2 == 0
        cols = 10
        offset = 50
      else
        cols = 9
        offset = 80
      j = 0
      x = offset
      while j < cols
        bodies.push Bodies.circle(
          x,
          y,
          2.5,
          isStatic: true,
          render: {
            fillStyle: 'black',
            strokeStyle: 'black'
          }
        )
        x = x + 60
        j++
      i++
    return

  placeWalls = ->
    y = 94
    i = 0
    angle1 = 0.523599
    angle2 = -0.523599
    while i < 12
      bodies.push Bodies.rectangle(67, y, 1, 60, isStatic: true, angle: angle2)
      bodies.push Bodies.rectangle(574, y, 1, 60, isStatic: true, angle: angle1)
      y = y + 50
      angle1 = angle1 * -1
      angle2 = angle2 * -1
      i++
    return

  placeBinWalls = ->
    x = 50
    i = 0
    while i < 10
      bodies.push Bodies.rectangle(x, 780, 5, 110, isStatic: true)
      x = x + 60
      i++
    return

  # module aliases
  Engine = Matter.Engine
  Render = Matter.Render
  World = Matter.World
  Bodies = Matter.Bodies

  # create an engine
  engine = Engine.create()
  engine.world = World.create({ gravity: { x: 0, y: 1, scale: 0.0009 } })

  # create a renderer
  render = Render.create(
    element: document.body
    engine: engine
    options: {
      height: 830,
      background: 'transparent',
      wireframes: false
    }
  )

  placeSlotNumbers = ->
    render.context.font = '30px Arial'
    console.log(render.context)
    i = 1
    while i < 10
      console.log(i)
      render.context.fillStyle = 'blue'
      render.context.fillText parseInt(i), 100, 200
      i++
    return

  # create static bodies
  placePegs()
  placeWalls()
  placeBinWalls()
  bodies.push Bodies.rectangle(400, 830, 800, 10, isStatic: true) # floor
  placeSlotNumbers()

  # add all of the bodies to the world
  World.add engine.world, bodies

  # run the engine
  Engine.run engine
  Render.run render

  dropChip = (gate) ->
    jitter = Math.floor(Math.random() * 20) - 10
    chip = new Chip(gate)
    console.log(chip.body())
    World.add engine.world, chip.body()
    Engine.update(engine)
    return

  $(document).on('keyup', ->
    console.log('1')
    dropChip(Math.floor(Math.random() * 9) + 1)
  )
  return

