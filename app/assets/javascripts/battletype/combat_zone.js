(function () {
  var BOTTOM_MARGIN = 80;
  
  this.CombatZone = function (element) {
    Object.assign(element, {
      randomFreeVerticalSlot: function () {
        return Math.max(0, Math.floor(Math.random() * element.height()) - BOTTOM_MARGIN);
      },
    });
    
    return element;
  };
}).call(this);
