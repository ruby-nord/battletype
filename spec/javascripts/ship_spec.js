/* globals Ship */
//= require battletype/ship

describe("Ship", function () {
  var element;
  
  beforeEach(function () {
    element = document.createElement("div");
  });
  
  it("adds the ship properties to the given element", function () {
    var ship = Ship(element, { word: "cat", type: "small", velocity: 12, targeted: false });
    
    expect(ship.word).toEqual("cat");
    expect(ship.type).toEqual("small");
    expect(ship.velocity).toEqual(12);
    expect(ship.targeted).toBeFalsy();
  });
  
  it("can be assigned a new word", function () {
    var wordElement = document.createElement("p");
    wordElement.className = "word";
    element.appendChild(wordElement);
    
    var ship = Ship(element, {});
    ship.word = "battle";
    
    expect(ship.word).toEqual("battle");
    expect(wordElement.textContent).toEqual("battle");
  });
  
  it("can be targeted", function () {
    var targetableElement = document.createElement("span");
    targetableElement.className = "ship";
    element.appendChild(targetableElement);
    
    var ship = Ship(element, {});
    ship.targeted = true;
    
    expect(targetableElement.classList).toContain("targeted_ship");
  });
  
  it("can be vertically positioned", function () {
    var ship = Ship(element, {});
    ship.positionY = 300;
    expect(ship.style.top).toEqual("300px");
  });
});
