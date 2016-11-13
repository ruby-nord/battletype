/* globals Dockyard */
//= require battletype/dockyard

describe("Battletype.Dockyard", function () {
  var dockyard;
  
  beforeEach(function () {
    var templates = document.createElement("template");
    templates.innerHTML = "<div data-ship-type='small'>SMALL</div>" +
                          "<div data-ship-type='medium'>MEDIUM</div>" +
                          "<div data-ship-type='large'>LARGE</div>" + 
                          "<div data-ship-type='mothership'>MOTHERSHIP</div>";
    
    dockyard = Dockyard(templates);
  });
  
  it("can build a ship", function () {
    var attributes = { type: "small", word: "dog", velocity: 12 };
    
    var result = dockyard.build(attributes);
    
    // A Ship is a DOM Element with extra properties
    expect(result instanceof Element).toBeTruthy();
    expect(result.innerHTML).toEqual("SMALL");
    expect(result.word).toEqual("dog");
    expect(result.type).toEqual("small");
    expect(result.velocity).toEqual(12);
  });
  
  describe("launching ships into a combat zone", function () {
    var ship, combatZone;
    
    beforeEach(function () {
      ship       = document.createElement("span");
      combatZone = document.createElement("div");
    });
    
    it("adds the ship to the combat zone", function () {
      dockyard.launch(ship, combatZone);
      expect(combatZone.childNodes.length).toEqual(1);
    });
  
    it("positions the ship on its Y axis on an available spot", function () {
      combatZone.randomFreeVerticalSlot = 123; // Jasmine can't spy on accessor properties so we stub instead
      
      dockyard.launch(ship, combatZone);
    
      expect(ship.positionY).toEqual(123);
    });
    
    it("keeps tracks of the launched ship", function () {
      ship.identifier = "foo";
      dockyard.launch(ship, combatZone);
    
      expect(dockyard.locateShip("foo")).toEqual(ship);
    });
  });
  
  it("can build a mothership", function () {
    var result = dockyard.buildMothership();
    
    expect(result instanceof Element).toBeTruthy();
    expect(result.innerHTML).toEqual("MOTHERSHIP");
    expect(result.hasBeenHit).toBeDefined();
    expect(result.hasBeenDestroyed).toBeDefined();
  });
  
  describe("launching the mothership into a combat zone", function () {
    var mothership, combatZone;
    
    beforeEach(function () {
      mothership = document.createElement("span");
      combatZone = document.createElement("div");
    });
    
    it("builds the mothership and adds it to the combat zone", function () {
      dockyard.launchMothership(mothership, combatZone);
      expect(combatZone.childNodes.length).toEqual(1);
    });
  });
});
