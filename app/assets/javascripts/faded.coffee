Faded.Interface = ->
  if $('#faded').length == 0
    return
  backgrounds = ''
  finishLine = 0
  urls = $('#a').data('urls').split(',')
  $(urls).each ->
    if backgrounds.length > 0
      backgrounds = backgrounds + ', '
    backgrounds = backgrounds + 'url(' + this + ')'
    return

  display = ->
    $('#a').css 'background-image', backgrounds
    $('#a').fadeIn 2000
    return

  finish = ->
    finishLine = finishLine + 1
    if finishLine == 5
      display()
    return

  preload = (array) ->
    $(array).each ->
      q = new Image
      q.onload = finish
      q.src = this
      return
    return

  preload urls
  return
