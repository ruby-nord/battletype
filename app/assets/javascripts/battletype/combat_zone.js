(function () {
  this.CombatZone = {
    _properties: {
      randomFreeVerticalSlot: {
        get: function () {
          return Math.floor(Math.random() * this.height() - 30) + 30;
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
