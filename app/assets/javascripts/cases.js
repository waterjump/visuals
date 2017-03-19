$(function(){

  var colorScheme = 'b';

  var chance = function(percent) {
    return Math.random() <= ( percent / 100.0 );
  };

  var randomColor = function() {
    if (chance(60)) {
      switch (colorScheme) {
        case 'b': // black and white
          return '#000';
          break;
        case 'g': // grey scale
          var greyColors = ['#000', '#555', '#aaa'];
          return greyColors[Math.floor(Math.random() * 3 )];
          break;
        case 'r': // random colors
          return '#'+Math.floor(Math.random()*16777215).toString(16);
      }
    } else {
      return '#ffffff';
    }
  };

  var colorise = function(klass) {
    if (chance(50)) {
      solidColor(klass);
    } else {
      twoColors(klass); 
    }
  };

  var solidColor = function(klass) {
    var color = randomColor();
    $('.' + klass).each(function(){
      $(this).css('border-color', 'transparent');
      $(this).css('background-color', color); 
    });
  };

  var twoColors = function(klass) {
    var color1 = randomColor();
    var color2 = randomColor();
    var borderNames = ['top', 'right', 'bottom', 'left'];
    var borderPairs = [['top', 'left'], ['top', 'right'], ['right', 'bottom'], ['bottom', 'left']];
    var borders;
    if (chance(30)) {
      borders = [borderNames[Math.floor(Math.random() * 4)]];
    } else {
      borders = borderPairs[Math.floor(Math.random() * 4)];
    }
    $('.' + klass).each(function(){
      $(this).css('border-color', 'transparent');
      var $slot = $(this);
      $.each(borders, function(index, value) {
        $slot.css('border-' + value + '-color', color1);
      });
      $(this).css('background-color', color2);
    });
  };

  $('.slot').on('mouseenter click', function() {
    colorise(this.classList[0]);
  });
  
  $(document).on('keypress', function(e) {
    switch (e.keyCode) {
      case 98:
        colorScheme = 'b';
        break;
      case 114:
        colorScheme = 'r';
        break;
      case 103:
        colorScheme = 'g';
        break;
      default:
        colorScheme = 'b';
    }
  });
});
