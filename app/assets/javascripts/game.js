//= require battletype

(function () {
  var start = function () {
    if ($("body").hasClass("games show")) {
      Battletype.init({
        playerId: $("#current_player").data("playerId"),
        inputDevice: document.getElementById("stdin"),
        attackFrequency: document.getElementById("attack"),
        defenseFrequency: document.getElementById("defense")
      });
    }
  };
  
  $(document).ready(start);
  $(document).on("page:load", start);
}).call(this);
