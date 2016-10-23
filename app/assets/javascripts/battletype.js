/* global Stdin, PS2EventRelay, CombatZone, Dockyard */

//= require battletype/stdin
//= require battletype/ps2_event_relay
//= require battletype/combat_zone
//= require battletype/dockyard

(function () {
  this.Battletype = {
    attacking: true,
    
    _eventsRelay: Object.create(PS2EventRelay),
    
    init: function(options) {
      this.playerId         = options.playerId;
      this.opponentId       = options.playerId;
      
      this.combatZone       = CombatZone.locate();
      
      this.attackFrequency  = options.attackFrequency;
      this.defenseFrequency = options.defenseFrequency;
      
      Dockyard.registerTemplate("small", document.getElementById("small_ship_template"));
      Dockyard.registerTemplate("medium", document.getElementById("medium_ship_template"));
      Dockyard.registerTemplate("large", document.getElementById("large_ship_template"));
      
      this._eventsRelay.addEventListener("entry", function (e) { this.transmitEntry(e.detail); }.bind(this), false);
      this._stdin = Object.create(Stdin, {
        inputDevice: { value: options.inputDevice },
        ps2Port: { value: this._eventsRelay }
      });
      this._stdin.powerOn();
      
    },
    incomingTransmission: function (payload) {
      switch(payload.code) {
      case "successful_attack":
        if (payload.player_id != this.playerId) { // TODO: comparer plutôt à opponentId
          Dockyard.launch({ word: payload.word, ship: payload.launched_ship }, this.combatZone);
        }
        break;
      case "failed_attack":
        if (payload.player_id == this.playerId) {
          console.log("Failed attack with word", payload.word);
          console.log("Error code", payload.error_codes);
        }
      }
    },
    transmitEntry: function (entry) {
      this.attacking ? this._transmitAttack(entry) : this._transmitDefense(entry);
      this._stdin.reset();
    },
    _transmitAttack: function (entry) {
      this.attackFrequency.querySelector("[name='word']").value = entry.word;
      
      $(this.attackFrequency).trigger("submit.rails");
    },
    _transmitDefense: function (entry) {
      this.defenseFrequency.querySelector("[name='word']").value = entry.word;
      this.defenseFrequency.querySelector("[name='perfectTyping']").value = entry.perfectTyping;
      
      $(this.defenseFrequency).trigger("submit.rails");
    },
  };
}).call(this);
