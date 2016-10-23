(function () {
  this.Mothership = {
    build: function (template) {
      var ship = Object.defineProperties($(template).clone(), {});
      return ship;
    }
  };
}).call(this);
