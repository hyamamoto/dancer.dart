# [dancer.dart](http://github.com/hyamamoto/dancer.dart)

A Dart package "dancer" is a minimalist's high level audio library for HTML5 with a Flash fallback. It is implemented as a wrapper for [dancer.js](https://github.com/jsantell/dancer.js) .

_version 0.4.0 (2/28/2014)_

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

* [Simple Player](http://htmlpreview.github.com/?http://github.com/hyamamoto/dancer.dart/blob/master/build/web/play_stop/play_stop.html) ([source](http://github.com/hyamamoto/dancer.dart/build/web/play_stop/))  
    Simple audio player with Play/Stop button.
* [FFT](http://htmlpreview.github.com/?http://github.com/hyamamoto/dancer.dart/blob/master/build/web/fft/fft.html) ([source](http://github.com/hyamamoto/dancer.dart/build/web/fft/))  
    Realtime 'Fast Fourier Transform' visualizer.
* [Waveform](http://htmlpreview.github.com/?http://github.com/hyamamoto/dancer.dart/blob/master/build/web/waveform/waveform.html) ([source](http://github.com/hyamamoto/dancer.dart/build/web/waveform/))  
    Waveform analysis.
* [Song Demo](http://htmlpreview.github.com/?http://github.com/hyamamoto/dancer.dart/blob/master/build/web/song_demo/song_demo.html) ([source](http://github.com/hyamamoto/dancer.dart/build/web/song_demo/))  
    Beat detection linked with 3D visual effects by three.js .

API Document
---

* [DartDoc](http://htmlpreview.github.com/?http://github.com/hyamamoto/dancer.dart/blob/master/docs/dancer.html)

Code Example
---

```dart

  final Dancer dancer = new Dancer();

  // Setup some kick.
  int kickCount = 0;
  final Kick kick = dancer.createKick(new KickOptions()
    ..decay = 0.02
    ..threshold = 0.3
    ..onKick = (num mag) { print( 'Kick[$kickCount]: mag = $mag'); kickCount++; }
    ..offKick = null
  ).on();

  // Schedule some event.
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

  // Load up audio file.
  dancer.load({ "src": "../songs/tonetest", "codecs": [ "ogg", "mp3"]});

  ...
  ...
  ...

  // Start playing  
  dancer.play();
```


Dependencies
---

* [dancer.js](https://github.com/jsantell/dancer.js/) - a backend javascript implementation.

Change Logs
----

** 0.4.0 (2/28/2014)**  
* Complete wrapper of dancer.js v0.4.0.
    
** 0.0.1 (2/27/2014)**  
* Prottype based on dancer.js 0.0.1

