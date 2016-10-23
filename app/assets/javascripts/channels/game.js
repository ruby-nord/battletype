(function () {
  var ready = function () {
    if ($("body").hasClass("games show")) {
      var gameId = $("#game_title").data("gameId");
      App.messages = App.cable.subscriptions.create(
        { channel: "GameChannel", game_id: gameId },
        { received: Battletype.incomingTransmission.bind(Battletype) }
      );
    }
  };
  
  $(document).ready(ready);
  $(document).on("page:load", ready);
}).call(this);
