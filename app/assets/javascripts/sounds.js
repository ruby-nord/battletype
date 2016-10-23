function hit() {
  playAudio('hit.mp3', false);
}

function explosion() {
  playAudio('explosion.mp3', false);
}

function spaceship() {
  playAudio('spaceship.mp3', false);
}

function ambiance() {
  playAudio('ambiance.mp3', true);
}

function playAudio(audioFile, loop) {
  var myAudio = new Audio('/sounds/'+audioFile);

  if(loop) {
    myAudio.addEventListener('ended', function() {
      this.currentTime = 0;
      this.play();
    }, false);
  }

  myAudio.play();
}