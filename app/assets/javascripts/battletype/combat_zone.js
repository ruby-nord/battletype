(function () {
  this.CombatZone = {
    _properties: {
      mode: {
        get: function () { return this.mode; },
        set: function (mode) {
          this._mode = mode;

          $(this)
            .removeClass("attack_mode defense_mode won_mode lost_mode") // FIXME
            .addClass(mode + "_mode"); // TODO tell-dont-ask
        }
      },
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
    _destroyShips: function (zone) {
      zone.find('.ship')
        .fadeOut("slow");
    },
    _displayAlertBox: function (mode) {
      var alertBox = AlertBox.build(document.getElementById("alert_box"));
      alertBox.title = "GAME OVER - ";

      switch (mode) {
      case "won":
        alertBox.title = alertBox.title + "YOU WON!";
        break;
      case "lost":
        alertBox.title = alertBox.title + "YOU LOSE!";
        break;
      }

      alertBox.content   = '<a href="' + window.location + '" data-turbolinks="false" class="button green">See the results</a>';
      alertBox.displayed = true;
    },
    close: function (mode) {
      var that = this;
      var zone = this.locate();

      this._destroyShips(zone);

      zone.find('.ship').promise()
        .done(function () {
          window.setTimeout(function () {
            zone.mode = mode;
            that._displayAlertBox(mode);
          },
          300);
        });
    },
    locate: function () {
      var zone = $("#combat_zone");
      Object.defineProperties(zone, this._properties);

      return zone;
    }
  };
}).call(this);
