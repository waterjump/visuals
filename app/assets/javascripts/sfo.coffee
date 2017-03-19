$ ->
  one_top = 0
  two_top = 500
  move = ->
    setTimeout( ->
      one_top = one_top + 1
      two_top = two_top + 1
      one_top = -499 if one_top == 501
      two_top = -499 if two_top == 501
      $('.one').css('top', one_top)
      $('.two').css('top', two_top)
      move()
      return
    , 7
    )
  move()
  return
