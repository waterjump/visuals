Faded.Card = (element, term, intrface) ->
  @status = 'inactive'
  @intrface = intrface
  @term = term
  @element = element
  @urls = []
  @images = []
  @finishLine = 0
  @backgroundsString = ->
    bgString = ''
    $(@urls).each ->
      if bgString.length > 0
        bgString = bgString + ', '
      bgString = bgString + 'url(' + this + ')'
      return
    return bgString

  @cancelPendingImages = ->
    $(@images).each ->
      console.log('cancelling ' + this.src) if !this.complete
      this.src = '' if !this.complete
      return
    return

  @finish = (->
    @finishLine = @finishLine + 1
    if @finishLine == 5
      @cancelPendingImages()
      @display()
    return).bind(@)

  @foo = ((src, index) ->
    @images[index] = new Image
    @images[index].onload = @finish
    @images[index].src = src
    return).bind(@)

  @preload = ->
    @urls.forEach(foo) #->
    return

  @otherCard = ->
    detector = ((card) ->
      card.element != @element
    ).bind(@)
    other = @intrface.cards.find(detector)
    return other

  @makeVisible = ( ->
    other = @otherCard()
    $(@element).fadeIn 5000, other.deactivate
    return).bind(@)

  @display = ->
    @status = 'active'
    other = @otherCard()
    $(other.element).css 'z-index', -1
    $(@element).css 'z-index', 10
    console.log(@backgroundsString())
    $(@element).css 'background-image', @backgroundsString()
    setTimeout(@makeVisible, 15000)
    return

  @ajaxDone = ((json) ->
    @urls = json
    @urls.forEach(@foo)
    return).bind(@)

  @init = (->
    console.log(@element + ' initializing now')
    @status = 'loading'
    $.ajax(url: '/faded?q=' + @intrface.seedTerm()).done @ajaxDone
  ).bind(@)

  @deactivate = (->
    console.log('deactivating' + @element)
    $(@element).fadeOut 10
    @images = []
    @finishLine = 0
    @init()
    return).bind(@)
  return

Faded.Interface = ->
  if $('#faded').length == 0
    return

  @recentTerms = []
  @seedTerm = ->
    terms = [
       'dog','berlin','moon','face','skyline','fruit','avery','love','smooth',
      'quiet','dawn','cat','subway','bath','code','matrix',
      'robot','3d graphics','north korea','forest','big wave',
      'pornography','illuminati','skeletal','painting','art','binary',
      'gary busey','galaxy','schwarzenegger','dress','earth','skyrim mod','acid house',
      'factory','wombat','library','ballet','pubic hair','ice hockey','hot dog'
      'metal gear solid','empty room','trump','shagohod','prince','tank','runway',
      'vaporwave','column','map','tie-dye','gears','bikini','rainbow','orchid',
      'tokyo','philadelphia','cgi','computer graphics','fighter jet','pattern'
      'synthesizer','katakana','water'
    ]
    term = terms[Math.floor(Math.random() * terms.length)]
    if ($.inArray(term, @recentTerms) == -1)
      @recentTerms.push(term)
      if @recentTerms.length >= 11
        @recentTerms.shift()
      return term
    else
      return @seedTerm()

  @aCard = new Faded.Card('#a', @seedTerm(), @)
  @bCard = new Faded.Card('#b', @seedTerm(), @)
  @cards = [@aCard, @bCard]
  @aCard.init()
  return
