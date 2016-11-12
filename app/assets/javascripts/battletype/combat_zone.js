(function () {
  this.CombatZone = {
    _properties: {
      randomFreeVerticalSlot: {
        get: function () {
          var hudHeight = 60;
          var maxHeight = this.height() - hudHeight;

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
