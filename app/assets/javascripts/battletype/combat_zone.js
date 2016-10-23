(function () {
  this.CombatZone = {
    _properties: {
      randomFreeVerticalSlot: {
        get: function () {
          return Math.floor(Math.random() * this.height()) - 80;
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
