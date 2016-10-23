/* globals Ship */
//= require battletype/ship

(function () {
  this.Dockyard = {
    _templates: {},
    
    launch: function (attributes, combatZone) {
      var newShip = Ship.build(this._templates[attributes.ship.type], attributes);
      
      newShip.positionY = combatZone.randomFreeVerticalSlot;
      newShip.appendTo(combatZone);
      console.log(newShip);
    },
    registerTemplate: function (name, element) {
      this._templates[name] = element;
    }
  };
}).call(this);
