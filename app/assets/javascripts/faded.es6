$(function() {
  console.log('faded loaded');
  /*
   * decaffeinate suggestions:
   * DS102: Remove unnecessary code created because of implicit returns
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  Faded.Card = function(element, term, intrface) {
    this.status = 'inactive';
    this.intrface = intrface;
    this.term = term;
    this.element = element;
    this.urls = [];
    this.images = [];
    this.finishLine = 0;
    this.backgroundsString = function() {
      let bgString = '';
      $(this.urls).each(function() {
        if (bgString.length > 0) {
          bgString = bgString + ', ';
        }
        bgString = bgString + 'url(' + this + ')';
      });
      return bgString;
    };

    this.cancelPendingImages = function() {
      $(this.images).each(function() {
        if (!this.complete) { console.log('cancelling ' + this.src); }
        if (!this.complete) { this.src = ''; }
      });
    };

    this.finish = () => {
      this.finishLine = this.finishLine + 1;
      if (this.finishLine === 5) {
        this.cancelPendingImages();
        this.display();
      }
      };

    this.foo = (src, index) => {
      this.images[index] = new Image;
      this.images[index].onload = this.finish;
      this.images[index].src = src;
      };

    this.preload = function() {
      this.urls.forEach(foo); //->
    };

    this.otherCard = function() {
      const detector = card => {
        return card.element !== this.element;
      };
      const other = this.intrface.cards.find(detector);
      return other;
    };

    this.makeVisible = () => {
      const other = this.otherCard();
      $(this.element).fadeIn(5000, other.deactivate);
      };

    this.display = function() {
      this.status = 'active';
      const other = this.otherCard();
      $(other.element).css('z-index', -1);
      $(this.element).css('z-index', 10);
      console.log(this.backgroundsString());
      $(this.element).css('background-image', this.backgroundsString());
      setTimeout(this.makeVisible, 15000);
    };

    this.ajaxDone = json => {
      this.urls = json;
      this.urls.forEach(this.foo);
      };

    this.init = () => {
      console.log(this.element + ' initializing now');
      this.status = 'loading';
      return $.ajax({url: '/faded?q=' + this.intrface.seedTerm()}).done(this.ajaxDone);
    };

    this.deactivate = () => {
      console.log('deactivating' + this.element);
      $(this.element).fadeOut(10);
      this.images = [];
      this.finishLine = 0;
      this.init();
      };
  };

  Faded.Interface = function() {
    if ($('#faded').length === 0) {
      return;
    }

    this.recentTerms = [];
    this.seedTerm = function() {
      const terms = [
         'dog','berlin','moon','face','skyline','fruit','avery','love','smooth',
        'quiet','dawn','cat','subway','bath','code','matrix',
        'robot','3d graphics','north korea','forest','big wave',
        'pornography','illuminati','skeletal','painting','art','binary',
        'gary busey','galaxy','schwarzenegger','dress','earth','skyrim mod','acid house',
        'factory','wombat','library','ballet','pubic hair','ice hockey','hot dog',
        'metal gear solid','empty room','trump','shagohod','prince','tank','runway',
        'vaporwave','column','map','tie-dye','gears','bikini','rainbow','orchid',
        'tokyo','philadelphia','cgi','computer graphics','fighter jet','pattern',
        'synthesizer','katakana','water', 'kraftwerk', 'döner'
      ];
      const urlParams = new URLSearchParams(window.location.search);
      const myParam = urlParams.get('q');
      return myParam;

      const term = terms[Math.floor(Math.random() * terms.length)];
      console.log(term);
      if ($.inArray(term, this.recentTerms) === -1) {
        this.recentTerms.push(term);
        if (this.recentTerms.length >= 11) {
          this.recentTerms.shift();
        }
        return term;
      } else {
        return this.seedTerm();
      }
    };

    this.aCard = new Faded.Card('#a', this.seedTerm(), this);
    this.bCard = new Faded.Card('#b', this.seedTerm(), this);
    this.cards = [this.aCard, this.bCard];
    this.aCard.init();
  };
});
