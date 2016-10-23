/* global Stdin, PS2EventRelay */

//= require battletype/stdin
//= require battletype/ps2_event_relay

(function () {
  this.Battletype = {
    attacking: true,
    
    _eventsRelay: Object.create(PS2EventRelay),
    
    init: function(options) {
      this._eventsRelay.addEventListener("entry", function (e) { this.transmitEntry(e.detail); }.bind(this), false);
      this.playerId         = options.playerId;
      
      this._stdin = Object.create(Stdin, {
        inputDevice: { value: options.inputDevice },
        ps2Port: { value: this._eventsRelay }
      });
      this._stdin.powerOn();
      
      this.attackFrequency  = options.attackFrequency;
      this.defenseFrequency = options.defenseFrequency;
    },
    transmitEntry: function (entry) {
      return this.attacking ? this._transmitAttack(entry) : this._transmitDefense(entry);
    },
    _transmitAttack: function (entry) {
      this.attackFrequency.querySelector("[name='word']").value = entry.word;
      return $(this.attackFrequency).trigger("submit.rails");
    },
    _transmitDefense: function (entry) {
      this.defenseFrequency.querySelector("[name='word']").value = entry.word;
      this.defenseFrequency.querySelector("[name='perfectTyping']").value = entry.perfectTyping;
      return $(this.defenseFrequency).trigger("submit.rails");
    },
  };
}).call(this);
