/* global Stdin, PS2EventRelay, CombatZone, Dockyard, Ship */

//= require battletype/stdin
//= require battletype/ps2_event_relay
//= require battletype/combat_zone
//= require battletype/dockyard
//= require battletype/ship

(function () {
  this.Battletype = {
    attacking: true,

    _eventsRelay: Object.create(PS2EventRelay),

    init: function(options) {
      this.playerId         = options.playerId;
      this.opponentId       = options.playerId;

      this.$combatZone       = CombatZone.locate();

      this.attackFrequency  = options.attackFrequency;
      this.defenseFrequency = options.defenseFrequency;
      this.bombingFrequency = document.getElementById("bombing_frequency");

      Dockyard.ps2Port = this._eventsRelay;
      Dockyard.registerTemplate("small", document.getElementById("small_ship_template"));
      Dockyard.registerTemplate("medium", document.getElementById("medium_ship_template"));
      Dockyard.registerTemplate("large", document.getElementById("large_ship_template"));
      Dockyard.registerTemplate("mothership", document.getElementById("mothership_template"));

      this.mothership = Dockyard.launchMothership(this.$combatZone);

      this._eventsRelay.addEventListener("entry", function (e) { this.transmitEntry(e.detail); }.bind(this), false);
      this._eventsRelay.addEventListener("switchMode", function (e) { this.switchMode(e.detail); }.bind(this), false);
      this._eventsRelay.addEventListener("bombDropped", function (e) { this._transmitBombing(e.detail); }.bind(this), false);

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
          Dockyard.launch({ word: payload.word, ship: payload.launched_ship }, this.$combatZone, this._eventsRelay);
        }
        break;
      case "failed_attack":
        if (payload.player_id == this.playerId) {
          console.log("Failed attack with word", payload.word);
          console.log("Error code", payload.error_codes);
        }
        break;
      case "successful_defense":
        // { code: 'successful_defense', player_id: player.id, word: word, strike: { gauge: player.strike_gauge, unlocked: player.unlocked_strike }}
        if (payload.player_id == this.playerId) {
          var ship = Ship.locate(payload.word);
          if (ship) { this.$combatZone.get(0).removeChild(ship); }
          // TODO: update gauge & unlock strike
        }
        break;
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
    _transmitBombing: function (ship) {
      ship.className += " leaving"; // The bombing ship leaves the scene
      this.mothership.hit = true;   // The mothership takes a hit

      this.bombingFrequency.elements["word"].value = ship.word;
      $(this.bombingFrequency).trigger("submit.rails");

      console.log("_transmitBombing", ship);
    },
    switchMode: function () {
      Battletype.attacking = !Battletype.attacking;
      console.log("Switched mode to Battletype.attacking = "+Battletype.attacking);
      if (Battletype.attacking) {
        this.$combatZone.removeClass("defense_mode").addClass("attack_mode");
        $("#stdin").removeClass("defense").addClass("attack");
      }
      else {
        this.$combatZone.removeClass("attack_mode").addClass("defense_mode");
        $("#stdin").removeClass("attack").addClass("defense");
      }
    },
  };
}).call(this);
