(function () {
  var ATTACK_MODE_CLASS = "attack";
  var DEFENSE_MODE_CLASS = "defense";
  var KEY_CODES_AND_VALUES_MAP = {
    "Backspace": 8,
    "Enter": 13,
    "Tab": 9
  };

  this.Stdin = function (element, ps2Port, scanner) {
    var perfectTyping = true;
    
    function handleKeyEvent(e) {
      switch (normalizedKey(e)) {
      case "Backspace":
        if (e.type == "keydown") {
          perfectTyping = false;
        }
        break;
      case "Enter":
        if (e.type == "keydown") {
          dispatchWordTypedEvent();
        }
        
        e.preventDefault();
        break;
      case "Tab":
        if (e.type == "keyup") {
          dispatchSwitchModeEvent();
        }
        
        e.preventDefault();
        break;
      default:
        if (e.type == "keyup") {
          var scannerResults = scanner(element.value);
          
          if (scannerResults) {
            scannerResults.$all.forEach(function () { this.targeted = false; });
            scannerResults.target.targeted = true;
          }
        }
        break;
      }
    }
    
    function dispatchWordTypedEvent() {
      var event = new CustomEvent("entry", { detail: { word: element.value, perfectTyping: perfectTyping } });
      ps2Port.dispatchEvent(event);
    }
    
    function dispatchSwitchModeEvent() {
      var event = new CustomEvent("switchMode", {});
      ps2Port.dispatchEvent(event);
    }
    
    function normalizedKey(e) {
      if (e.key !== undefined) {
        return e.key;
      } else if (e.keyIdentifier !== undefined) {
        if (KEY_CODES_AND_VALUES_MAP[e.keyIdentifier]) {
          return e.keyIdentifier;
        } else {
          var keyCode = parseInt(e.keyIdentifier.substr(2), 16); // Extract the code in base16 and convert it to base10
          return keyCodeToKeyValue(keyCode);
        }
      } else if (e.keyCode !== undefined) {
        return keyCodeToKeyValue(e.keyCode);
      }
    }
    
    function keyCodeToKeyValue(keyCode) {
      return Object.keys(KEY_CODES_AND_VALUES_MAP).find(function (k) {
        return KEY_CODES_AND_VALUES_MAP[k] == keyCode;
      });
    }
    
    var stdin = {
      powerOn: function () {
        element.addEventListener("keydown", handleKeyEvent, { capture: true }); // Let's only care for keyups for now
        element.addEventListener("keyup", handleKeyEvent, { capture: true }); // Let's only care for keyups for now
      },
      powerOff: function () {
        element.removeEventListener("keydown", handleKeyEvent, { passive: true });
        element.removeEventListener("keyup", handleKeyEvent, { passive: true });
      },
      reset: function () {
        perfectTyping = true,
        element.value = "";
      },
      indicateAttackMode: function () {
        element.classList.remove(DEFENSE_MODE_CLASS);
        element.classList.add(ATTACK_MODE_CLASS);
      },
      indicateDefenseMode: function () {
        element.classList.remove(ATTACK_MODE_CLASS);
        element.classList.add(DEFENSE_MODE_CLASS);
      },
      perfectTyping: function () {
        return perfectTyping;
      }
    };
    
    stdin.powerOn();
    return stdin;
  };
}).call(this);
