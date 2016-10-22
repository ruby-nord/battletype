/* global Stdin */
(function () {
  this.Battletype = {
    listeners: {},
    
    init: function(options) {
      this.mode = "attack";
      this.addEventListener("wordTyped", function (e) { this.transmitEntry(e.detail); }, false);
      this._stdin = Object.create(Stdin, {
        $input: { value: options.input },
        terminal: { value: this }
      });
      this._stdin.powerOn();
      
      this.$attack  = options.attack;
      this.$defense = options.defense;
    },
    transmitEntry: function (entry) {
      if (this.mode == "attack") {
        this.$attack.querySelector("[name='word']").value = entry.word;
        this.$attack.submit();
      }
      
      return true;
    },
    
    // Event implementation
    // TODO: move to a mixin ?
    addEventListener: function (type, callback) {
      if (!(type in this.listeners)) {
        this.listeners[type] = [];
      }
      this.listeners[type].push(callback);
    },
    removeEventListener: function (type, callback) {
      if (!(type in this.listeners)) { return; }
      var stack = this.listeners[type];
      for (var i = 0, l = stack.length; i < l; i++) {
        if(stack[i] === callback){
          stack.splice(i, 1);
          return this.removeEventListener(type, callback);
        }
      }
    },
    dispatchEvent: function (event) {
      if (!(event.type in this.listeners)) {
        return;
      }
      var stack = this.listeners[event.type];
      event.target = this;
      for(var i = 0, l = stack.length; i < l; i++) {
        stack[i].call(this, event);
      }
    }
  };
}).call(this);
