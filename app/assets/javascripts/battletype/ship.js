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
      },
      targeted: {
        get: function () { return this._targeted; },
        set: function (t) {
          this._targeted = Boolean(t);
          
          var s = this.querySelector(".ship");
          if (this._targeted) {
            s.classList.add("targeted_ship");
          } else if (s.classList.contains("targeted_ship")) {
            s.classList.remove("targeted_ship");
          }
          
          return this._targeted;
        }
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
