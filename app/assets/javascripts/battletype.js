/* global Stdin */
(function () {
  this.Battletype = {
    init: function(id) {
      this._stdin = Object.create(Stdin, {
        $input: { value: document.getElementById(id) }
      });
      this._stdin.powerOn();
    }
  };
}).call(this);
