/* globals Ship, Mothership */
//= require battletype/ship
//= require battletype/mothership

(function () {
  this.Dockyard = {
    _templates: {},
    
    launch: function (attributes, combatZone) {
      var newShip = Ship.build(this._templates[attributes.ship.type], attributes);
      
      newShip.positionY = combatZone.randomFreeVerticalSlot;
      newShip.appendTo(combatZone);
      console.log(newShip);
    },
    launchMothership: function (combatZone) {
      var mothership = Mothership.build(this._templates["mothership"]);
      mothership.appendTo(combatZone);
    },
    registerTemplate: function (name, element) {
      this._templates[name] = element;
    }
  };
}).call(this);
