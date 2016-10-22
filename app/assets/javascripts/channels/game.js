var ready = function (){
  console.log("listening to SampleChannel");
  var game_id = $("input[name=game_id]").val();
  App.messages = App.cable.subscriptions.create({channel: 'GameChannel', game_id: game_id}, {
    received: function(data) {
      console.log(data);
      return $('#messages').append("<tr><td>" + data.user + " says : </td><td>" + data.message + "</td></tr>");
    },
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);