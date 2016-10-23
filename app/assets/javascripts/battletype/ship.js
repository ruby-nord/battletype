(function () {
  this.Ship = {
    _properties: {
      word: {
        get: function () { return this._word; },
        set: function (w) {
          this._word = w;
          $(this).find("p.word").text(this._word);
        }
      },
      velocity: {
        get: function () { return this._word; },
        set: function (v) { this._velocity = v; }
      },
      damage: {
        get: function () { return this._damage; },
        set: function (d) { this._damage = d; }
      }
    },
    
    build: function (template, attributes) {
      var ship = Object.defineProperties($(template).clone(), this._properties);
      ship.word = attributes.word;
      ship.velocity = attributes.velocity;
      ship.damage = attributes.damage;
      
      return ship;
    }
  };
}).call(this);
