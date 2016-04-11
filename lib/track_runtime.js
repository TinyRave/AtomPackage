/**
 * The TinyRave environment for use in the track sandbox
 *
 * The single API we want to expose here is runTrackSource(source)
*/

if (window.audioWrapper === undefined)
{
  window.audioWrapper = new window.AudioWrapper();
}

window.runEncodedTrackSource = function(encodedSource) {
  var source = decodeURIComponent(encodedSource);
  window.audioWrapper.setTrackSource(source, 100 * 24 * 60 * 60); // Default duration 100 days
  window.audioWrapper.play();
}

window.stopTrack = function() {
  window.audioWrapper.stop();
}
