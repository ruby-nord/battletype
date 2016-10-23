/* globals Ship */
(function () {
  this.Ship = {
    _properties: {
      word: {
        get: function () { return this._word; },
        set: function (w) {
          this._word = w;
          this.id = Ship._shipIdFromWord(this._word);
          this.querySelector("p.word").textContent = this._word;
        }
      },
      velocity: {
        get: function () { return this._word; },
        set: function (v) { this._velocity = v; }
      },
      damage: {
        get: function () { return this._damage; },
        set: function (d) { this._damage = d; }
      },
      positionY: {
        get: function () { /* TODO */ },
        set: function (y) { $(this).css({ top: y + "px" }); }
      }
    },
    
    build: function (template, attributes) {
      var ship = Object.defineProperties($(template).clone().get(0), this._properties);
      ship.word = attributes.word;
      ship.velocity = attributes.velocity;
      ship.damage = attributes.damage;
      
      return ship;
    },
    locate: function (word, combatZone) {
      return $("#" + this._shipIdFromWord(word), combatZone).get(0);
    },
    _shipIdFromWord: function (word) {
      return "ship_" + word;
    }
  };
}).call(this);
