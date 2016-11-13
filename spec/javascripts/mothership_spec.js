/* globals Mothership */
//= require battletype/mothership

describe("Motherhip", function () {
  var element, hittableElement;
  
  beforeEach(function () {
    element = document.createElement("div");
    hittableElement = document.createElement("div");
    hittableElement.id = "target_mothership";
    element.appendChild(hittableElement);
  });
  
  describe("when hit", function () {
    it("temporarily adds a CSS class to its main element", function () {
      var mothership = Mothership(element, {});
      jasmine.clock().install();
    
      mothership.hasBeenHit();
    
      expect(hittableElement.classList).toContain("hit");
      jasmine.clock().tick(901);
      expect(hittableElement.classList).not.toContain("hit");
      
      jasmine.clock().uninstall();
    });
  });
  
  describe("when destroyed", function () {
    it("adds a CSS class to its main element", function () {
      var mothership = Mothership(element, {});
    
      mothership.hasBeenDestroyed();
    
      expect(hittableElement.classList).toContain("destroyed");
    });
  });
});
