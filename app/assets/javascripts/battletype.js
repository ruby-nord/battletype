/* global Stdin, PS2EventRelay, CombatZone, Dockyard, Ship, LifeOMeter */

//= require battletype/stdin
//= require battletype/logs
//= require battletype/ps2_event_relay
//= require battletype/combat_zone
//= require battletype/dockyard
//= require battletype/ship
//= require battletype/player
//= require battletype/life_o_meter

(function () {
  this.Battletype = {
    attacking: true,

    _eventsRelay: Object.create(PS2EventRelay),

    init: function(options) {
      this.playerId         = options.playerId;
      this.opponentId       = options.playerId;

      this.$combatZone       = CombatZone.locate();

      this.attackFrequency  = document.getElementById("attack");
      this.defenseFrequency = document.getElementById("defense");
      this.bombingFrequency = document.getElementById("bombing_frequency");

      Dockyard.ps2Port = this._eventsRelay;
      Dockyard.registerTemplate("small", document.getElementById("small_ship_template"));
      Dockyard.registerTemplate("medium", document.getElementById("medium_ship_template"));
      Dockyard.registerTemplate("large", document.getElementById("large_ship_template"));
      Dockyard.registerTemplate("mothership", document.getElementById("mothership_template"));

      this.mothership = Dockyard.launchMothership(this.$combatZone);

      this.player   = Player.build(document.getElementById("current_player_nickname"));
      this.opponent = Player.build(document.getElementById("opponent_nickname"));

      this.playerLifeOMeter   = LifeOMeter.activate(document.getElementById("life_player"));
      this.opponentLifeOMeter = LifeOMeter.activate(document.getElementById("life_opponent"));

      this._eventsRelay.addEventListener("entry", function (e) { this.transmitEntry(e.detail); }.bind(this), false);
      this._eventsRelay.addEventListener("switchMode", function (e) { this.switchMode(e.detail); }.bind(this), false);
      this._eventsRelay.addEventListener("bombDropped", function (e) { this._transmitBombing(e.detail); }.bind(this), false);

      // TODO: factory pattern
      this._logs = Object.create(Logs, {
        boxTag: { value: document.getElementById("log_system") },
      });

      this._stdin = Object.create(Stdin, {
        inputDevice:  { value: document.getElementById("stdin") },
        ps2Port:      { value: this._eventsRelay },
        scanner:      { value: this.scanForShip.bind(this) }
      });
      this._stdin.powerOn();
    },
    incomingTransmission: function (payload) {
      switch(payload.code) {
      case "successful_attack":
        if (payload.player_id == this.playerId) {
          this._logs.displayMessage(payload.code);
        }
        else { // TODO: comparer plutôt à opponentId
          audio_spaceship("right");
          Dockyard.launch({ word: payload.word, ship: payload.launched_ship }, this.$combatZone, this._eventsRelay);
        }
        break;
      case "failed_attack":
        if (payload.player_id == this.playerId) {
          this._logs.displayMessage(payload.code, payload.error_codes);

          console.log("Failed attack with word", payload.word);
          console.log("Error code", payload.error_codes);
        } else {
          // TODO
        }
        break;
      case "successful_defense":
        if (payload.player_id == this.playerId) {
          var ship = this.$combatZone.find("#ship_" + payload.word).get(0); // FIXME: Battletype shouldn't locate the ships itself
          if (ship) { this.$combatZone.get(0).removeChild(ship); }
          
          this._logs.displayMessage(payload.code);
          // TODO: update gauge & unlock strike
        } else {
          // TODO
        }
        break;
      case "failed_bombing":
        if (payload.player_id == this.playerId) {
          this._logs.displayMessage(payload.code, payload.error_codes);
        }
        break;
      case "failed_defense":
        if (payload.player_id == this.playerId) {
          this._logs.displayMessage(payload.code, payload.error_codes);
        }
        break;
      case "successful_bombing":
        this._logs.displayMessage(payload.code);

        if (payload.player_id == this.playerId) {
          console.info(payload.code);
          this.opponentLifeOMeter.life = payload.bombed_mothership.life;
        } else {
          this.playerLifeOMeter.life = payload.bombed_mothership.life;
        }
        break;
      case "game_won":
        this._logs.displayMessage(payload.code);

        if (payload.player_id == this.playerId) {
          // TODO
          console.log("\o/ You won!");
        } else {
          // TODO
          console.log(":( You lose!");
          this.mothership.destroyed = true;
        }
        break;
      case "player_joined":
        if (payload.player_id != this.playerId) {
          var nickname = payload.nickname;
          Battletype.opponent.nickname = payload.nickname;
          this._logs.displayMessage(payload.code);
        }
        break;
      case "player_nickname_changed":
        var nickname = payload.nickname;

        if (payload.player_id == this.playerId) {
          Battletype.player.nickname = payload.nickname;
          this._logs.displayMessage(payload.code);
        } else {
          Battletype.opponent.nickname = payload.nickname;
        }
        break;
      }
    },
    scanForShip: function (text) {
      if (!this.attacking) {
        var target = this.$combatZone.find("[id^='ship_" + text + "']");  // FIXME: Battletype shouldn't locate the ships itself
        if (target) {
          return {
            target: target.get(0),
            $all: this.$combatZone.ships
          };
        }
      }
    },
    transmitEntry: function (entry) {
      this.attacking ? this._transmitAttack(entry) : this._transmitDefense(entry);
      this._stdin.reset();
    },
    _transmitAttack: function (entry) {
      audio_spaceship("left");
      this.attackFrequency.elements["word"].value = entry.word;
      $(this.attackFrequency).trigger("submit.rails");
    },
    _transmitDefense: function (entry) {
      this.defenseFrequency.elements["word"].value = entry.word;
      this.defenseFrequency.elements["perfect_typing"].value = entry.perfectTyping;

      $(this.defenseFrequency).trigger("submit.rails");
    },
    _transmitBombing: function (ship) {
      ship.className += " leaving"; // The bombing ship leaves the scene
      this.mothership.hit = true;   // The mothership takes a hit

      this.bombingFrequency.elements["word"].value = ship.word;
      $(this.bombingFrequency).trigger("submit.rails");
    },
    switchMode: function () {
      Battletype.attacking = !Battletype.attacking;

      if (Battletype.attacking) {
        this.$combatZone.removeClass("defense_mode").addClass("attack_mode"); // TODO tell-dont-ask
        this._stdin.indicateAttackMode();
      }
      else {
        this.$combatZone.removeClass("attack_mode").addClass("defense_mode"); // TODO tell-dont-ask
        this._stdin.indicateDefenseMode();
      }
    },
  };
}).call(this);
