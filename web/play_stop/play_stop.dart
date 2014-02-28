import 'dart:html';

import 'package:dancer/dancer.dart';

void main() {
  
  print('Supported: ' + Dancer.isSupported());

  final Dancer dancer = new Dancer();

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

  // You can also use <audio> tag on a host page to load an audio file
  // AudioElement audioSource = querySelector("#audio");
  // dancer.loadFromAudio(audioSource);

  // Load an audio file.
  const String AUDIO_FILE = '../songs/tonetest';
  // const String AUDIO_FILE = '../songs/deux_hirondelles';
  dancer.load({ "src": AUDIO_FILE, "codecs": [ 'ogg', 'mp3']});

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

      // Print debuggy messages on console.
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
