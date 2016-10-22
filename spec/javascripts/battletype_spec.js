//= require jquery
//= require battletype

describe("Battletype", function() {
  var inputField  = $("<input>").get(0);
  var attackForm  = $("<form><input name='word'></form>").get(0);
  var defenseForm = $("<form><input name='word'><input name='perfectTyping'></form>").get(0);
  
  it("transmits the typed word to the server", function() {
    spyOn(attackForm, "submit");
    Battletype.init({ input: inputField, attack: attackForm, defense: defenseForm });
    Battletype.mode = "attack";
    
    var entry = { word: "Elephant", perfectTyping: false };
    
    Battletype.transmitEntry(entry);
    expect(attackForm).toHaveBeenCalled();
  });
});
