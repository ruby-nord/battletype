/* globals CombatZone */
//= require battletype/combat_zone

describe("CombatZone", function () {
  var element;
  
  beforeEach(function () {
    element = document.createElement("div");
  });
  
   // TODO: wrtie a better spec that actually tests the implementation
  it("can return a free vertical slot on its right edge", function () {
    var combatZone = CombatZone(element);
    expect(combatZone.randomFreeVerticalSlot).toBeDefined();
  });
});
