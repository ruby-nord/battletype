(function () {
  var TOP_MARGIN = 15;
  
  this.CombatZone = function (element) {
    var hud    = element.getElementsByClassName("hud")[0];
    var hudTop = hud ? hud.offsetHeight : 0;
    
    Object.assign(element, {
      randomFreeVerticalSlot: function () {
        var maxHeight = this.height() - hudTop - TOP_MARGIN;
        return Math.floor(Math.random() * maxHeight);
      },
    });
    
    return element;
  };
}).call(this);
