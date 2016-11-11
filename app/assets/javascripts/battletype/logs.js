(function () {
  var LOG_CODES_AND_TYPES_MAP = {
    "failed_attack":           "attack",
    "failed_bombing":          "attack",
    "failed_defense":          "defense",
    "game_won":                "game",
    "player_joined":           "player",
    "player_nickname_changed": "player",
    "successful_attack":       "attack",
    "successful_bombing":      "bomb",
    "successful_defense":      "defense",
  };

  var LOG_CODES_AND_MESSAGES_MAP = {
    "failed_attack":           "OOPS! Attack failed",
    "failed_bombing":          "OOPS! Bombing failed",
    "failed_defense":          "OOPS! Defense failed",
    "game_won":                "Game finished!",
    "player_joined":           "Opponent joined",
    "player_nickname_changed": "Nickname changed",
    "successful_attack":       "New ship launched!",
    "successful_bombing":      "Mothership hit!",
    "successful_defense":      "Ship destroyed!",
  };

  var ERROR_CODES_AND_MESSAGES_MAP = {
    "attack": {
      "english_word":                 "Must be an English word",
      "long_enough":                  "Word is not long enough",
      "not_running":                  "Game is not running!",
      "unique_case_insensitive_word": "Word must be unique"
    },
    "bomb": {
      "attacked_player_ship": "You tried to bomb your mothership!!",
      "ship_not_found":       "Ship to bomb not found"
    },
    "defense": {
      "already_destroyed":    "Ship is already destroyed!",
      "bomb_already_dropped": "Bomb already dropped",
      "player_ship":          "It's your own ship!",
      "ship_not_found":       "Ship not found",
      "wrong_case":           "Words are case sensitive"
    }
  };

  this.Logs = {
    boxTag: { writable: true },
    displayMessage: function (code, errorCodes) {
      this.reset();

      var type      = LOG_CODES_AND_TYPES_MAP[code]
      var logMesage = LOG_CODES_AND_MESSAGES_MAP[code];
      var logError  = undefined;

      if (errorCodes != undefined) {
        logError  = ERROR_CODES_AND_MESSAGES_MAP[type][errorCodes[0]];
        logMesage = logMesage + ' - ' + logError
      }

      $(this.boxTag)
        .text(logMesage)
        .fadeIn("slow")
        .delay(1500)
        .fadeOut("slow"); // TODO tell-dont-ask & remove jQuery
    },
    reset: function () {
      this.boxTag.innerHTML = '';
    }
  };

}).call(this);
