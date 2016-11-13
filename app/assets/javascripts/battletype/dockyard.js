/* globals Ship, Mothership */
//= require battletype/ship
//= require battletype/mothership

(function () {
  this.Dockyard = function (template, ps2Port) {
    var SHIP_TYPE_DATA_ATTRIBUTE = "data-ship-type";
  
    var launchedShips = {};
    var shipTemplates = Array.prototype.slice.call(template.content.querySelectorAll("[" + SHIP_TYPE_DATA_ATTRIBUTE + "]")).reduce(function (o, t) {
      var type = t.getAttribute(SHIP_TYPE_DATA_ATTRIBUTE);
      o[type] = t;
      return o;
    }, {});
    
    return {
      // TODO: handle missing template
      build: function (attributes) {
        var ship = Ship(shipTemplates[attributes.type].cloneNode(true), attributes);
        ship.addEventListener("animationend", this._bombingEventDispatcherFor(ship), false);
        
        return ship;
      },
      launch: function (ship, combatZone) {
        ship.positionY = combatZone.randomFreeVerticalSlot;
        launchedShips[ship.identifier] = ship;
        
        combatZone.appendChild(ship);
      },
      locateShip: function (word) {
        return launchedShips[word];
      },
      launchMothership: function (combatZone) {
        var mothership = Mothership.build(shipTemplates["mothership"]);
        $(mothership).appendTo(combatZone); // TODO: do without jQuery
      
        return mothership;
      },
      registerTemplate: function (name, element) {
        shipTemplates[name] = element;
      },
      _bombingEventDispatcherFor: function (ship) {
        return function () {
          var event = new CustomEvent("bombDropped", { detail: ship });
          ps2Port.dispatchEvent(event);
        };
      }
    };
  };
}).call(this);
