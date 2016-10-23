(function () {
  this.LifeOMeter = {
    _properties: {
      life: {
        get: function () { return this._life; },
        set: function (l) {
          this._life = l;
          
          var turningOff = window.setInterval(function () {
            if (this.leds.length > this._life) {
              this.removeChild(this.leds[this.leds.length - 1]);
            } else {
              window.clearInterval(turningOff);
            }
          }.bind(this), 100);
        }
      },
      leds: {
        get: function () {
          return this.querySelectorAll(".life_bar");
        }
      }
    },
    activate: function (node) {
      var lifeOMeter = Object.defineProperties(node, this._properties);
      lifeOMeter.life = lifeOMeter.leds.length;
      
      return lifeOMeter;
    }
  };
}).call(this);
