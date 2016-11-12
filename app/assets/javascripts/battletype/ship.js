(function () {
  this.Ship = function (element, attributes) {
    var WORD_ELEMENT_SELECTOR = "p.word";
    var SHIP_ELEMENT_SELECTOR = ".ship";
    var TARGETED_CLASS        = "targeted_ship";
    var ID_ROOT               = "ship_";
    
    var word, targeted;
    var wordElement = element.querySelector(WORD_ELEMENT_SELECTOR);
    var shipElement = element.querySelector(SHIP_ELEMENT_SELECTOR);
    
    Object.defineProperties(element, {
      word: {
        get: function () {
          return word;
        },
        set: function (newWord) {
          word = newWord;
          
          if (wordElement) {
            element.id = ID_ROOT + word;
            wordElement.textContent = word;
          }
        }
      },
      type: {
        value: attributes.type
      },
      velocity: {
        value: attributes.velocity
      },
      positionY: {
        get: function () { return element.style.top; },
        set: function (y) { element.style.top = y + "px"; }
      },
      targeted: {
        get: function () {
          return targeted;
        },
        set: function (t) {
          targeted = Boolean(t);
          
          if (shipElement) {
            targeted ? shipElement.classList.add(TARGETED_CLASS) : shipElement.classList.remove(TARGETED_CLASS);
          }
        }
      }
    });
    
    element.word = attributes.word;
    
    return element;
  };
}).call(this);
