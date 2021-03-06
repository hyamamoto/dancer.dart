import 'dart:html';
import 'dart:async';

import 'package:dancer/dancer.dart';

const String AUDIO_FILE = '../songs/tonetest';

void loaded (Dancer dancer) {
  final 
    loading = document.getElementById( 'loading' ),
    anchor  = document.createElement('A'),
    supported = Dancer.isSupported(),
    hasSupport = supported != null && supported.isNotEmpty;

  anchor.text = hasSupport ? 'Play!' : 'Close';
  anchor.setAttribute( 'href', '#' );
  loading.innerHtml = '';
  loading.append( anchor );

  if ( !hasSupport ) {
    final p = document.createElement('P')
      ..text = """Your browser does not currently support either Web Audio API or 
Audio Data API. The audio may play, but the visualizers will not move 
to the music; check out the latest Chrome or Firefox browsers!""";
    loading.append( p );
  }

  anchor.addEventListener( 'click', (e) {
    dancer.play();
    document.getElementById('loading').style.display = 'none';
  });
}

void main() {
  final
    CanvasElement fft = document.getElementById( 'fft' );
    CanvasRenderingContext2D ctx = fft.context2D;
  
  // Flash audio fallback support
  Dancer.setOptions({
    'flashSWF' : 'packages/dancer/src/js/soundmanager2.swf',
    'flashJS ' : 'packages/dancer/src/js/soundmanager2.js'
  });
  
  // Create a Dancer instance.
  final Dancer dancer = new Dancer();
  
  // Add a Kick for color flashing.
  final Kick kick = dancer.createKick( new KickOptions()
    ..onKick = (mag) {
      ctx.fillStyle = '#ff0077';
    }
    ..offKick = (mag) {
      ctx.fillStyle = '#666';
    }).on();
  
  // Load an audio
  dancer
    .fft( fft, new FFTOptions()..fillStyle = '#666' )
    .load({ 'src': AUDIO_FILE, 'codecs': [ 'ogg', 'mp3' ]});
  
  final String supported = Dancer.isSupported();
  if ( supported == null || supported.isEmpty) {
    loaded(dancer);
  }
  new Timer(new Duration(milliseconds:0), () {
    if (!dancer.isLoaded()) {
      dancer.bind( 'loaded', () => loaded(dancer) );
    } else {
      loaded(dancer);
    }
  });
}
