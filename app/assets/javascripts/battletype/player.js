(function () {
  this.Player = {
    _properties: {
      nickname: {
        get: function () { return this._nickname; },
        set: function (nickname) {
          this._nickname = nickname;

          $(this)
            .text(nickname)
            .fadeIn("slow")
            .blur();
        }
      }
    },
    build: function (node) {
      var player = Object.defineProperties(node, this._properties);
      return player;
    }
  };
}).call(this);
