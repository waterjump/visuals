$(function(){
  if ($('#faded').length === 0) {
    return;
  }
  var backgrounds = '';
  var finishLine = 0;
  var urls = $('.layer').data('urls').split(',');

  $(urls).each(function(){
    if (backgrounds.length > 0) {
      backgrounds = backgrounds + ', ';
    }
    backgrounds = backgrounds + 'url(' + this + ')';
  });

  var display = function() {
    $('.layer').css('background-image', backgrounds);
    $('.layer').fadeIn(2000);
  };

  var finish = function() {
    finishLine = finishLine + 1
    if (finishLine === 5) {
      display();
    }
  };

  var preload = function(array) {
    $(array).each(function(){
      var q = new Image
      q.onload = finish;
      q.src = this;
    });
  };

  preload(urls);
});
