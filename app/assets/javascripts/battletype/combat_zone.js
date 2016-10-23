(function () {
  this.CombatZone = {
    _properties: {
      randomFreeVerticalSlot: {
        get: function () {
          return Math.floor(Math.random() * this.height() - 80) + 80;
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
