//= require battletype

$(function () {
  Battletype.init({
    inputDevice: document.getElementById("stdin"),
    attackFrequency: document.getElementById("attack"),
    defenseFrequency: document.getElementById("defense")
  });
});
