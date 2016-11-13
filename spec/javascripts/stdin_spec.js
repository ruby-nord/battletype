/* global Stdin */
//= require battletype/stdin
function typeKeys(element, keys) {
  element = element || document;
  
  keys.forEach(function (key) {
    var event = document.createEvent("Events");
    event.initEvent("keydown", true, true);
    event.key = key;
    
    element.dispatchEvent(event);
  });
}

describe("Stdin", function() {
  var stdin;
  var ps2Port = { dispatchEvent: function () {} };
  var inputDevice = document.createElement("input");
  
  beforeEach(function() {
    stdin = Stdin(inputDevice, ps2Port);
    stdin.powerOn();
  });
  
  it("records the pressing of the backspace key", function () {
    typeKeys(inputDevice, ["A", "B", "Backspace", "C"]);
    
    expect(stdin.perfectTyping()).toBeFalsy();
  });
  
  it("triggers an event when the Enter key is pressed", function () {
    spyOn(ps2Port, "dispatchEvent");
    
    typeKeys(inputDevice, ["A", "B", "Enter"]);
    
    expect(ps2Port.dispatchEvent).toHaveBeenCalledWith(jasmine.any(CustomEvent));
  });
});
