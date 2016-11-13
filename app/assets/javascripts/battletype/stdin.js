(function () {
  var KEY_CODES_AND_VALUES_MAP = {
    "Backspace": 8,
    "Enter": 13,
    "Tab": 9
  };

  this.Stdin = {
    powerOn: function () {
      this.reset();
      this.inputDevice.addEventListener("keydown", this, { capture: true }); // Let's only care for keyups for now
      this.inputDevice.addEventListener("keyup", this, { capture: true }); // Let's only care for keyups for now
    },
    powerOff: function () {
      this.inputDevice.removeEventListener("keydown", this, { passive: true });
      this.inputDevice.removeEventListener("keyup", this, { passive: true });
    },
    reset: function () {
      this._typingMistake    = false,
      this.inputDevice.value = "";
    },
    indicateAttackMode: function () {
      $(this.inputDevice).removeClass("defense").addClass("attack");
    },
    indicateDefenseMode: function () {
      $(this.inputDevice).removeClass("attack").addClass("defense");
    },
    perfectTyping: function () {
      return ! this._typingMistake;
    },
    currentEntry: function () {
      return { word: this.inputDevice.value, perfectTyping: this.perfectTyping() };
    },
    handleEvent: function (e) {
      switch (this._normalizedKey(e)) {
      case "Backspace":
        if (e.type == "keydown") {
          this._typingMistake = true;
        }
        break;
      case "Enter":
        if (e.type == "keydown") {
          this._dispatchWordTypedEvent();
        }
        
        e.preventDefault();
        break;
      case "Tab":
        if (e.type == "keyup") {
          this._dispatchSwitchModeEvent();
        }
        
        e.preventDefault();
        break;
      default:
        if (e.type == "keyup") {
          var scannerResults = this.scanner(this.inputDevice.value);
          
          if (scannerResults) {
            scannerResults.$all.forEach(function () { this.targeted = false; });
            scannerResults.target.targeted = true;
          }
        }
        break;
      }
    },
    _dispatchWordTypedEvent: function () {
      var event = new CustomEvent("entry", { detail: this.currentEntry() });
      this.ps2Port.dispatchEvent(event);
    },
    _dispatchSwitchModeEvent: function () {
      var event = new CustomEvent("switchMode", {});
      this.ps2Port.dispatchEvent(event);
    },
    _normalizedKey: function (e) {
      if (e.key !== undefined) {
        return e.key;
      } else if (e.keyIdentifier !== undefined) {
        if (KEY_CODES_AND_VALUES_MAP[e.keyIdentifier]) {
          return e.keyIdentifier;
        } else {
          var keyCode = parseInt(e.keyIdentifier.substr(2), 16); // Extract the code in base16 and convert it to base10
          return this._keyCodeToKeyValue(keyCode);
        }
      } else if (e.keyCode !== undefined) {
        return this._keyCodeToKeyValue(e.keyCode);
      }
    },
    _keyCodeToKeyValue: function (keyCode) {
      return Object.keys(KEY_CODES_AND_VALUES_MAP).find(function (k) {
        return KEY_CODES_AND_VALUES_MAP[k] == keyCode;
      });
    }
  };
}).call(this);
