(function () {
  this.AlertBox = {
    _properties: {
      title: {
        get: function () { return this._title; },
        set: function (title) {
          this._title = title;
          this.querySelector(".title").textContent = title;
        }
      },
      content: {
        get: function () { return this._content; },
        set: function (content) {
          this._content = content;
          this.querySelector(".content").innerHTML = content;
        }
      },
      displayed: {
        get: function () { return this._displayed; },
        set: function (v) {
          this._displayed = Boolean(v);

          if (this._displayed) {
            $(this)
              .delay(500)
              .fadeIn("slow");
          } else {
            $(this)
              .delay(500)
              .fadeOut("slow");
          }

          return this._hit;
        }
      }
    },
    build: function (node) {
      var alertBox = Object.defineProperties(node, this._properties);
      return alertBox;
    }
  };
}).call(this);
