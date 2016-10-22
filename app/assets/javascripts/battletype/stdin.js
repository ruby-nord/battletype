(function () {
  var BACKSPACE_KEY_VALUE = "Backspace";
  var BACKSPACE_KEY_CODE  = 8;
  
  this.Stdin = {
    $input: { writable: true },
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
    value: function () {
      return this.$input.value;
    },
    handleEvent: function (e) {
      var registerTypingMistake;
      
      switch(e.type) {
      case "keydown":
        if (e.key !== undefined) {
          registerTypingMistake = (e.key == BACKSPACE_KEY_VALUE);
        } else if (e.keyIdentifier !== undefined) {
          var keyCode = parseInt(e.keyIdentifier.substr(2), 16); // Extract the base16 and convert it to base10
          registerTypingMistake = (keyCode == BACKSPACE_KEY_CODE);
        } else if (e.keyCode !== undefined) {
          registerTypingMistake = (e.keyCode == BACKSPACE_KEY_CODE);
        }
        
        if (registerTypingMistake) {
          this._typingMistake = true;
        }
        break;
      case "keyup":
        // some code here...
        break;
      }
    }
  };
}).call(this);
