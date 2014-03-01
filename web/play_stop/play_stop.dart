import 'dart:html';

import 'package:dancer/dancer.dart';

const String AUDIO_FILE = '../songs/tonetest';

void main() {
  print('Supported: ' + Dancer.isSupported());

  // Create a Dancer instance.
  final Dancer dancer = new Dancer();
  
  // Add a Kick for color flashing.
  int kickCount = 0;
  final Kick kick = dancer.createKick(new KickOptions()
    ..decay = 0.02
    ..threshold = 0.3
    ..onKick = (num mag) { print( 'Kick[$kickCount]: mag = $mag'); kickCount++; }
    ..offKick = null
  ).on();

  // Schedule time based functions.
  dancer.onceAt( 1, () {
    print("Scheduled func: 1 sec");
  }).between( 1.5, 2.0, () {
    print("Scheduled func: 1.5 sec - 2.0 sec");
  }).onceAt( 2.5, (){
    final num freq = dancer.getFrequency( 400);
    print("Scheduled func: 2.5 sec: $freq");
  }).after( 4, () {
    final num time = dancer.getTime();
    print("Scheduled func: 4 sec +: $time");
    //kick.off();
  });

  // You can also use <audio> tag on a host page to load an audio file
  // AudioElement audioSource = querySelector("#audio");
  // dancer.loadFromAudio(audioSource);

  // Load an audio file 'tonetest.ogg'
  dancer.load({ "src": AUDIO_FILE, "codecs": [ 'ogg']});

  // Setup "Play/Pause" button.
  querySelector("#sample_text_id")
    ..text = "Play/Pause"
    ..onClick.listen( (MouseEvent e) {
      
      if (dancer.isPlaying()) {        
        print('Button: pause!');
        kick.off();
        dancer.pause();
      } else {
        print('Button: play!');
        kick.on();
        dancer.play();
      }

      // Print debuggy messages.
      print('\tisPlaying: ' + dancer.isPlaying().toString());

      print('\tisLoaded: ' + dancer.isLoaded().toString());
      
      var spectrum = dancer.getSpectrum();
      print( "\tSpectrum: " + spectrum.toString());
      
      var time = dancer.getTime();
      print( "\tTime: " + time.toString());
      
      var volume = dancer.getVolume();
      print( "\tVolume: " + volume.toString());
      
      var progress = dancer.getProgress();
      print( "\tProgress: " + progress.toString());
      
      var events = dancer.events;
      print( "\tRegistered Events: " + events.keys.toString());
    });
}
