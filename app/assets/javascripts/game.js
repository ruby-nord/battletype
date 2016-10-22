//= require battletype

$(function () {
  if ($("body").hasClass(".games.show")) {
    Battletype.init({
      inputDevice: document.getElementById("stdin"),
      attackFrequency: document.getElementById("attack"),
      defenseFrequency: document.getElementById("defense")
    });
  }
});
