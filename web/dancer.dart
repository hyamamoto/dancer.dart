import 'dart:html';

import 'package:dancer/dancer.dart';

void main() {
  final Dancer dancer = new Dancer("./songs/zircon_devils_spirit.ogg");

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

  querySelector("#sample_text_id")
    ..text = "Click me!"
    ..onClick.listen( (MouseEvent e) {
      
      final DancerAdapter adapter =  dancer.audioAdapter;
      if (adapter.isPlaying) {        
        beat.on();
        adapter.stop();
      } else {
        beat.off();
        adapter.play();
      }
      
      var spectrum = adapter.getSpectrum();
      print( "s:" + spectrum.toString());
      var time = adapter.getTime();
      print( "t:" + time.toString());
      var event = dancer.events;
      print( "e:" + event.toString());
    });
}
