(function () {
  var STARTING_LIFE = 10;
  
  this.LifeOMeter = function (element) {
    var life = STARTING_LIFE;
    
    Object.defineProperties(element, {
      life: {
        get: function () { return life; },
        set: function (newLife) {
          life = newLife;
          
          var turningOff = window.setInterval(function () {
            var leds = element.querySelectorAll(".life_bar");
            if (leds.length > life) {
              element.removeChild(leds[leds.length - 1]);
            } else {
              window.clearInterval(turningOff);
            }
          }, 100);
        }
      }
    });
    
    return element;
  };
}).call(this);
