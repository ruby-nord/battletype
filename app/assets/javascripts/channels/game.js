var ready = function (){
  console.log("listening to SampleChannel");
  var game_id = $("input[name=game_id]").val();
  App.messages = App.cable.subscriptions.create({channel: 'GameChannel', game_id: game_id}, {
    received: function(data) {
      console.log(data);
    },
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);