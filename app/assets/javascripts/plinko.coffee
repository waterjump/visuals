# module aliases
Engine = Matter.Engine
World = Matter.World
Bodies = Matter.Bodies
Events = Matter.Events

circles = []
rectangles = []
polygons = []
engine = undefined
board = undefined

class Chip
  constructor: (@gate) ->

  jitter: ->
    Math.floor(Math.random() * 20) - 10
  body: ->
    Matter.Bodies.circle(
      80.5 + ((@gate - 1) * 60) + @jitter(),
      20,
      22,
      friction: 0.001,
      restitution: 0.75,
      sleepThreshold: 10
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
      circles.push Bodies.circle(
        x,
        y,
        2.5,
        isStatic: true
      )
      x = x + 60
      j++
    i++
  return

placeWalls = ->
  rectangles.push Bodies.rectangle(25,449,50,760, isStatic: true)
  rectangles.push Bodies.rectangle(615,449,50,760, isStatic: true)
  leftWallTriangle = Matter.Vertices.fromPath('0 0 30 50 0 100')
  rightWallTriangle = Matter.Vertices.fromPath('0 0 0 100 -30 50')
  i = 0
  while i < 6
    polygons = polygons.concat Bodies.fromVertices(60, 119 + 100 * i, leftWallTriangle, isStatic: true)
    polygons = polygons.concat Bodies.fromVertices(578, 119 + 100 * i, rightWallTriangle, isStatic: true)
    i++

placeBinWalls = ->
  x = 50
  i = 0
  while i < 10
    rectangles.push Bodies.rectangle(x, 780, 5, 110, isStatic: true)
    x = x + 60
    i++
  return

placeSlotNumbers = (p) ->
  i = 1
  while i < 10
    p.textSize(32)
    p.text(parseInt(i), 10 + i * 60, 55)
    i++
  return

placeBinScores = (p) ->
  p.translate(0, 820)
  p.rotate(-Math.PI / 2 )
  scores = ['100','500','1000','- 0 -','10,000','- 0 -','1000','500','100']
  i = 0
  while i < scores.length
    p.text(scores[i], 10, 90 + i * 60)
    i++

placeSensors = ->
  sens = Bodies.rectangle(80, 788, 55, 80, isSensor: true, isStatic: true)
  rectangles.push sens
  return

dropChip = (gate) ->
  chip = new Chip(gate)
  console.log(chip.body())
  circles.push(chip.body())
  World.add engine.world, chip.body()
  Engine.update(engine)
  return

$(document).on('keyup', ->
  dropChip(Math.floor(Math.random() * 9) + 1)
)


rectX = (body) ->
  body.position.x - (rectWidth(body) / 2)

rectY = (body) ->
  body.position.y - (rectHeight(body) / 2)

rectWidth = (body) ->
  body.bounds.max.x - body.bounds.min.x

rectHeight = (body) ->
  body.bounds.max.y - body.bounds.min.y

play = ->
  setTimeout((->
    dropChip(Math.floor(Math.random() * 9) + 1)
    play()
    return
  ), 4000)
  return

myp = new p5 (p) ->
  p.setup = ->
    p.frameRate(30)
    engine = Engine.create(enableSleeping: true)
    engine.world = World.create({ gravity: { x: 0, y: 1, scale: 0.0009 } })

    board = p.createCanvas(641, 850)
    placePegs()
    placeWalls()
    placeBinWalls()
    placeSensors()
    rectangles.push Bodies.rectangle(320, 830, 641, 10, isStatic: true) # floor

    World.add engine.world, circles
    World.add engine.world, rectangles
    World.add engine.world, polygons

    Engine.run engine
    return

  p.draw = ->
    p.clear()
    $.each engine.world.bodies, (_i, body) ->
      p.ellipse(body.position.x, body.position.y, body.circleRadius * 2) if body.label == "Circle Body"
      p.rect(rectX(body), rectY(body), rectWidth(body), rectHeight(body)) if body.label == "Rectangle Body"
      if body.label == "Body"
        vc = body.vertices
        i = 0
        while i < vc.length - 1
          p.line(vc[i].x, vc[i].y, vc[i+1].x, vc[i+1].y)
          i++
        p.line(vc[0].x, vc[0].y, vc[vc.length-1].x, vc[vc.length-1].y)

      Events.on body, 'sleepStart', (event) ->
        if !(body.isStatic)
          Matter.Composite.remove(engine.world, body)
        return
      return
    placeSlotNumbers(p)
    placeBinScores(p)
    return

play()
