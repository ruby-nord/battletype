//= require battletype

(function () {
  var start = function () {
    if ($("body").hasClass("games show")) {
      Battletype.init({
        playerId: $("#current_player").data("playerId"),
      });

      $('#current_player_nickname').on('focus', function() {
        $(this).select();
      });
    }
  };

  $(document).ready(start);
  $(document).on("page:load", start);
}).call(this);
