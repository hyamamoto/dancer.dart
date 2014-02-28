import 'dart:html';

import 'package:dancer/dancer.dart';

void loaded (Dancer dancer) {
  var
    loading = document.getElementById( 'loading' ),
    anchor  = document.createElement('A'),
    supported = Dancer.isSupported(),
    hasSupported = supported != null && supported.isNotEmpty;

  anchor.append( document.createElement( 'span')
      ..text = hasSupported ? 'Play!' : 'Close' );
  anchor.setAttribute( 'href', '#' );
  loading.innerHtml = '';
  loading.append( anchor );

  if ( !hasSupported ) {
    var p = document.createElement('P');
    p.append( document.createElement( 'span')
      ..text='Your browser does not currently support either Web Audio API or Audio Data API. The audio may play, but the visualizers will not move to the music; check out the latest Chrome or Firefox browsers!' );
    loading.append( p );
  }

  anchor.addEventListener( 'click', (e) {
    dancer.play();
    document.getElementById('loading').style.display = 'none';
  });
  
}

void main() {
  const String AUDIO_FILE = '../songs/tonetest';
  // const String AUDIO_FILE = '../songs/dubstep_bass';
  // const String AUDIO_FILE = '../songs/deux_hirondelles';
    
    final CanvasElement fft = document.getElementById( 'fft' );
    final CanvasRenderingContext2D ctx = fft.context2D;

    Dancer.setOptions({
      'flashSWF' : 'packages/dancer/src/js/soundmanager2.swf',
      'flashJS ' : 'packages/dancer/src/js/soundmanager2.js'
    });

    final Dancer dancer = new Dancer();
    final Kick kick = dancer.createKick( new KickOptions()
      ..onKick = (mag) {
        ctx.fillStyle = '#ff0077';
      }
      ..offKick = (mag) {
        ctx.fillStyle = '#666';
      }).on();

    dancer
      .fft( fft, new FFTOptions()..fillStyle = '#666' )
      .load({ 'src': AUDIO_FILE, 'codecs': [ 'ogg', 'mp3' ]});

    final String supported = Dancer.isSupported();
    if ( supported != null && supported.isNotEmpty) {
      loaded(dancer);
    }
    if (!dancer.isLoaded()) {
      dancer.bind( 'loaded', () => loaded(dancer) );
    } else {
      loaded(dancer);
    }
}
