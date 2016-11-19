(function () {
  this.CombatZone = {
    _properties: {
      randomFreeVerticalSlot: {
        get: function () {
          var bottomHudHeight = document.getElementById('life_player').offsetHeight;
          var margin = 15; // in pixels
          var maxHeight = this.height() - bottomHudHeight - margin;

          return Math.floor(Math.random() * maxHeight);
        }
      },
      ships: {
        get: function () {
          return this.find(".small_ship, .medium_ship, .large_ship"); // FIXME
        }
      }
    },
    locate: function () {
      var zone = $("#combat_zone");
      Object.defineProperties(zone, this._properties);

      return zone;
    }
  };
}).call(this);
