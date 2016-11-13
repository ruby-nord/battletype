(function () {
  this.Mothership = function (element) {
    var HIT_TARGET_ELEMENT_SELECTOR = "#target_mothership";
    var HIT_CLASS = "hit";
    var DESTROYED_CLASS = "destroyed";
    var HIT_ANIMATION_LENGTH = 900;
    
    var hitTarget = element.querySelector(HIT_TARGET_ELEMENT_SELECTOR);
    
    Object.assign(element, {
      hasBeenHit: function () {
        if (hitTarget) {
          hitTarget.classList.add(HIT_CLASS);
          window.setTimeout(function () { hitTarget.classList.remove(HIT_CLASS); }, HIT_ANIMATION_LENGTH);
        }
      },
      hasBeenDestroyed: function () {
        if (hitTarget) {
          hitTarget.classList.add(DESTROYED_CLASS);
        }
      }
    });
    
    return element;
  };
}).call(this);
