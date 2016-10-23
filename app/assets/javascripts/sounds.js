var ambiance;

var ready = function () {
  ambiance = new Howl({
    src: ['/sounds/ambiance.mp3'],
    loop: true,
    autoplay: true
  });
}

$(document).ready(ready);
$(document).on("page:load", ready);

function hit() {
  playAudio('hit.mp3', 0);
}

function explosion() {
  playAudio('explosion.mp3', 0);
}

function spaceship(position) {
  if(position == "left") {
      x = -1;
  }
  else {
    x = 1;
  }
  playAudio('spaceship.mp3', x);
}

function playAmbiance() {
  ambiance.play();
}

function pauseAmbiance() {
  ambiance.pause();
}

function playAudio(audioFile, x) {
  new Howl({
    src: ['/sounds/'+audioFile],
    pos: (x, 0, 0),
    autoplay: true
  });
}