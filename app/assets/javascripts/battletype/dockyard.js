/* globals Ship, Mothership */
//= require battletype/ship
//= require battletype/mothership

(function () {
  this.Dockyard = {
    ps2Port: undefined,
    _templates: {},

    launch: function (attributes, combatZone) {
      var positionY;
      var newShip = Ship.build(this._templates[attributes.ship.type], attributes);

      newShip.addEventListener("animationend", this._bombingEventDispatcherFor(newShip), false);

      // first we need to append the ship
      // before setting its position (otherwise position is undefined)
      $(newShip).appendTo(combatZone); // TODO: do without jQuery
      newShip.positionY = combatZone.randomFreeVerticalSlot - $(newShip).height(); // TODO: do without jQuery

      return newShip;
    },
    launchMothership: function (combatZone) {
      var mothership = Mothership.build(this._templates["mothership"]);
      $(mothership).appendTo(combatZone); // TODO: do without jQuery

      return mothership;
    },
    registerTemplate: function (name, element) {
      this._templates[name] = element;
    },
    _bombingEventDispatcherFor: function (ship) {
      return function () {
        var event = new CustomEvent("bombDropped", { detail: ship });
        this.ps2Port.dispatchEvent(event);
      }.bind(this);
    }
  };
}).call(this);
