(function () {
  var KEY_CODES_AND_VALUES_MAP = {
    "Backspace": 8,
    "Enter": 13
  };

  this.Stdin = {
    inputDevice: { writable: true },
    ps2Port: { writable: true },

    powerOn: function () {
      this.reset();
      this.inputDevice.addEventListener("keydown", this, { passive: true });
    },
    powerOff: function () {
      this.inputDevice.removeEventListener("keydown", this, { passive: true });
    },
    reset: function () {
      this._typingMistake    = false,
      this.inputDevice.value = "";
    },
    perfectTyping: function () {
      return ! this._typingMistake;
    },
    currentEntry: function () {
      return { word: this.inputDevice.value, perfectTyping: this.perfectTyping() };
    },
    handleEvent: function (e) {
      var pressedKey;

      switch(e.type) {
      case "keydown":
        if (e.key !== undefined) {
          pressedKey = e.key;
        } else if (e.keyIdentifier !== undefined) {
          if (KEY_CODES_AND_VALUES_MAP[e.keyIdentifier]) {
            pressedKey = e.keyIdentifier;
          } else {
            var keyCode = parseInt(e.keyIdentifier.substr(2), 16); // Extract the code in base16 and convert it to base10
            pressedKey = this._keyCodeToKeyValue(keyCode);
          }
        } else if (e.keyCode !== undefined) {
          pressedKey = this._keyCodeToKeyValue(e.keyCode);
        }
        break;
      case "keyup":
        // some code here...
        break;
      }

      switch(pressedKey) {
      case "Backspace":
        this._typingMistake = true;
        break;
      case "Enter":
        this._dispatchWordTypedEvent();
        break;
      case "Tab":
        this._dispatchSwitchModeEvent();
        break;
      }
    },
    _keyCodeToKeyValue: function (keyCode) {
      return Object.keys(KEY_CODES_AND_VALUES_MAP).find(function (k) {
        return KEY_CODES_AND_VALUES_MAP[k] == keyCode;
      });
    },
    _dispatchWordTypedEvent: function () {
      var event = new CustomEvent("entry", { detail: this.currentEntry() });
      this.ps2Port.dispatchEvent(event);
    },
    _dispatchSwitchModeEvent: function () {
      var event = new CustomEvent("switch", {});
      this.ps2Port.dispatchEvent(event);
    }
  };
}).call(this);
