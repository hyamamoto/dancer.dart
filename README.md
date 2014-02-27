dancer.dart
======

* this library is not released *

http://github.com/hyamamoto/dancer.dart

Example
---

```dart

  Dancer dancer = new Dancer("./zircon_devils_spirit.ogg");

  BeatOptions beatOptions = new BeatOptions()
    ..onBeat = (dancer, mag) => print( 'Beat!')
    ..offBeat = (dancer, mag) => print( 'no beat.');
  Beat beat = new Beat(dancer, beatOptions);

  dancer.onceAt( 10, (dancer) {
    print("10 sec");
  }).between( 10, 60, ( dancer) {
    print("10 sec - 60 sec: frame");
  }).after( 60, ( dancer) {
    print("60 sec: " + dancer.getFrequency( 400 ));
  }).onceAt( 120, (dancer) {
    print("120 sec");
    beat.off();
  });

  DancerAdapter adapter =  dancer.audioAdapter;
  if (adapter.isPlaying) {        
    adapter.stop();
  } else {
    adapter.play();
  }
```

Requirements
----

**HTML5 Playback with Web Audio or Audio Data** Chrome and Firefox are both supported out of the box

Dependencies
---

* [dancer.js](https://github.com/jsantell/dancer.js/) - a backend javascript implementation.

Change Logs
----
**v0.0.1 (2/27/2014)**
* Implementation based on dancer.js version 0.0.1

