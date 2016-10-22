//= require jquery
//= require battletype

describe("Battletype", function() {
  var inputField  = $("<input>").get(0);
  var attackForm  = $("<form><input name='word'></form>").get(0);
  var defenseForm = $("<form><input name='word'><input name='perfectTyping'></form>").get(0);
  
  describe("When attacking", function () {
    beforeEach(function () {
      Battletype.attacking = true;
    });
    
    it("transmits the typed word to the server through the attack form", function() {
      spyOn(attackForm, "submit");
      Battletype.init({ inputDevice: inputField, attackFrequency: attackForm, defenseFrequency: defenseForm });
      
      var entry = { word: "Starbucks" };
      
      Battletype.transmitEntry(entry);
      expect(attackForm.submit).toHaveBeenCalled();
      expect(attackForm.elements[0].value).toEqual("Starbucks");
    });
  });
  
  describe("When defending", function () {
    beforeEach(function () {
      Battletype.attacking = false;
    });
    
    it("transmits the typed word to the server through the defense form", function() {
      spyOn(defenseForm, "submit");
      Battletype.init({ inputDevice: inputField, attackFrequency: attackForm, defenseFrequency: defenseForm });
      
      var entry = { word: "Cylon", perfectTyping: true };
      
      Battletype.transmitEntry(entry);
      expect(defenseForm.submit).toHaveBeenCalled();
      expect(defenseForm.elements[0].value).toEqual("Cylon");
      expect(defenseForm.elements[1].value).toEqual("true");
    });
  });
});
