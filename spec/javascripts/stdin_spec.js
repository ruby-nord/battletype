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
  var terminal = { dispatchEvent: function () {} };
  var $input = document.createElement("input");
  
  beforeEach(function() {
    stdin = Object.create(Stdin, { $input: { value: $input }, terminal: { value: terminal } });
    stdin.powerOn();
  });
  
  it("records the pressing of the backspace key", function () {
    typeKeys($input, ["A", "B", "Backspace", "C"]);
    
    expect(stdin.perfectTyping()).toBeFalsy();
  });
  
  it("triggers an event when the Enter key is pressed", function () {
    spyOn(terminal, "dispatchEvent");
    
    typeKeys($input, ["A", "B", "Enter"]);
    
    expect(terminal.dispatchEvent).toHaveBeenCalledWith(jasmine.any(CustomEvent));
  });
});
