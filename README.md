# [dancer.dart](http://github.com/hyamamoto/dancer.dart)

A Dart package "dancer" is a high level audio library for HTML5 with a Flash fallback. It is implemented as a [dancer.js](https://github.com/jsantell/dancer.js) wrapper.

_version 0.4.0+4 (3/1/2014)_

Features
---
* Use real-time audio waveform and frequency data and map it to any arbitrary visualization
* Use Dancer to get audio data from any preexisting audio source
* Leverage kick detection into your visualizations
* Simple API to time callbacks and events to any section of a song
* Supports Web Audio (webkit/mozilla), Audio Data (mozilla) and flash fallback (v9+)
* Extensible framework supporting plugins and custom behaviours

Live Examples
---

* [Simple Player](http://freepress.jp/dev/dancer.dart/examples/play_stop/play_stop.html) ([source](http://github.com/hyamamoto/dancer.dart/tree/master/web/play_stop/))  
    Simple audio player with Play/Pause button.
* [FFT](http://freepress.jp/dev/dancer.dart/examples/fft/fft.html) ([source](http://github.com/hyamamoto/dancer.dart/tree/master/web/fft/))  
    Realtime 'Fast Fourier Transform' visualizer.
* [Waveform](http://freepress.jp/dev/dancer.dart/examples/waveform/waveform.html) ([source](http://github.com/hyamamoto/dancer.dart/tree/master/web/waveform/))  
    Waveform analysis.
* [Song Demo](http://freepress.jp/dev/dancer.dart/examples/song_demo/song_demo.html) ([source](http://github.com/hyamamoto/dancer.dart/tree/master/web/song_demo/))  
    Kick detection linked with 3D visual effects by three.js .

API Document
---

* http://htmlpreview.github.com/?http://github.com/hyamamoto/dancer.dart/blob/master/docs/dancer.html

Code Example
---

```dart

  final Dancer dancer = new Dancer();

  // Setup a kick detection.
  int kickCount = 0;
  final Kick kick = dancer.createKick(new KickOptions()
    ..decay = 0.02
    ..threshold = 0.3
    ..onKick = (num mag) { print( 'Kick[$kickCount]: mag = $mag'); kickCount++; }
    ..offKick = null
  ).on();

  // Schedule time based functions.
  dancer.onceAt( 1, () {
    print("Scheduled Func: 1 sec");
  }).between( 1.5, 2.0, () {
    print("Scheduled Func: 1.5 sec - 2.0 sec");
  }).onceAt( 2.5, (){
    final num freq = dancer.getFrequency( 400);
    print("Scheduled Func: 2.5 sec: $freq");
  }).after( 4, () {
    final num time = dancer.getTime();
    print("Scheduled Func: 4 sec +: $time");
    //kick.off();
  });

  // Load up an audio file 'tonetext.ogg'
  dancer.load({ "src": "../songs/tonetest", "codecs": [ "ogg"]});

  ...
  ...
  ...

  // Start playing  
  dancer.play();
```

Dependencies
---

* [dancer.js](https://github.com/jsantell/dancer.js/) - a backend javascript implementation (included inside a 'packages/dancer' directory).

Change Logs
----

** 0.4.0+4 (3/1/2014) **
* Dependency fix (newly released 'browser =0.10.0' is still buggy.)
* Updated all examples.

** 0.4.0 (2/28/2014)**  
* Complete wrapper of dancer.js v0.4.0.

License
----

dancer.dart is released under the [the MIT license](LICENSE) by Hiroshi Yamamoto <higon@freepress.jp>