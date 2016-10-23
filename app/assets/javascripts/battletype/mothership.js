(function () {
  this.Mothership = {
    _properties: {
      hit: {
        get: function () { return this._hit; },
        set: function (v) {
          this._hit = Boolean(v);
          
          if (this._hit) {
            var $hitTarget = $(this).find("#target_mothership");
            $hitTarget.addClass("hit");
            window.setTimeout(function () { $hitTarget.removeClass("hit"); }, 1500);
          }
          
          return this._hit;
        }
      }
    },
    build: function (template) {
      var ship = Object.defineProperties($(template).clone().get(0), this._properties);
      return ship;
    }
  };
}).call(this);
