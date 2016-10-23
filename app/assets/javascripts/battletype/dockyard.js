/* globals Ship */
//= require battletype/ship

(function () {
  this.Dockyard = {
    _templates: {},
    
    launch: function (attributes, space) {
      var newShip = Ship.build(this._templates[attributes.ship.type], attributes);
      
      // TODO: position verticale aléatoire
      newShip.appendTo(space);
    },
    registerTemplate: function (name, element) {
      this._templates[name] = element;
    }
  };
}).call(this);
