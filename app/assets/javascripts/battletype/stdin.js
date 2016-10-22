(function () {
  var KEY_CODES_AND_VALUES_MAP = {
    "Backspace": 8,
    "Enter": 13
  };
  
  this.Stdin = {
    $input: { writable: true },
    terminal: { writable: true },
    
    powerOn: function () {
      this._typingMistake = false,
      this.$input.value = "";
      this.$input.addEventListener("keydown", this, { passive: true });
      this.$input.addEventListener("keyup", this, { passive: true });
    },
    powerOff: function () {
      this.$input.removeEventListener("keydown", this, { passive: true });
      this.$input.removeEventListener("keyup", this, { passive: true });
    },
    perfectTyping: function () {
      return ! this._typingMistake;
    },
    currentEntry: function () {
      return { word: this.$input.value, perfectTyping: this.perfectTyping() };
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
      }
    },
    _keyCodeToKeyValue: function (keyCode) {
      return Object.keys(KEY_CODES_AND_VALUES_MAP).find(function (k) {
        return KEY_CODES_AND_VALUES_MAP[k] == keyCode;
      });
    },
    _dispatchWordTypedEvent: function () {
      var event = new CustomEvent("wordTyped", { detail: this.currentEntry() });
      this.terminal.dispatchEvent(event);
    }
  };
}).call(this);
