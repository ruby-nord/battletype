/* globals LifeOMeter */
//= require battletype/combat_zone

describe("LifeOMeter", function () {
  var element;
  
  it("progressively removes leds when its life decreases", function () {
    element = document.createElement("ul");
    for (var i = 0, led; i < 10; i++) {
      led = document.createElement("li");
      led.className = "life_bar";
      element.appendChild(led);
    }
    
    var lifeOMeter = LifeOMeter(element);
    jasmine.clock().install();
    
    lifeOMeter.life = 7;
    jasmine.clock().tick(101);
    expect(lifeOMeter.querySelectorAll("li.life_bar").length).toEqual(9);
    jasmine.clock().tick(101);
    expect(lifeOMeter.querySelectorAll("li.life_bar").length).toEqual(8);
    jasmine.clock().tick(101);
    expect(lifeOMeter.querySelectorAll("li.life_bar").length).toEqual(7);
    jasmine.clock().tick(101);
    expect(lifeOMeter.querySelectorAll("li.life_bar").length).toEqual(7); // the fourth led should stil be there
    
    jasmine.clock().uninstall();
  });
});
