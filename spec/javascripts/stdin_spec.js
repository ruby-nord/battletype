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
  var $input = document.createElement("input");
  
  beforeEach(function() {
    stdin = Object.create(Stdin, { $input: { value: $input } });
    stdin.powerOn();
  });
  
  it("records the pressing of the backspace key", function () {
    typeKeys($input, ["A", "B", "Backspace", "C"]);
    
    expect(stdin.perfectTyping()).toBeFalsy();
  });
});
