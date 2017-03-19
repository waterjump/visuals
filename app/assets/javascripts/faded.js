$(function(){
  if ($('#faded').length === 0) {
    return;
  }
  var backgrounds = '',
      positions = '';
  var urls = $('.layer').data('urls').split(',');
  console.log(urls);
  $('.layer').fadeOut(10);
  var preload = function(array) {
    $(array).each(function(){
      $('<img/>')[0].src = this;
    });
    $('.layer').css('background-image', backgrounds);
    $('.layer').fadeIn();
  }

  $(urls).each(function(){
    if (backgrounds.length > 0) {
      backgrounds = backgrounds + ', ';
    }
    backgrounds = backgrounds + 'url(' + this + ')';
  });

  console.log(backgrounds);
  preload(urls);
  // $('.layer').css('background-image', backgrounds);
});
