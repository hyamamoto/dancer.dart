import 'dart:html';
import 'dart:math' as math;

import 'package:js/js.dart' as js;

import 'package:dancer/dancer.dart';

// three.js proxies
final js.Proxy THREE = js.context.THREE;
final js.Proxy Scene = js.context.THREE.Object3D;
final js.Proxy Vector3 =  js.context.THREE.Vector3;
final js.Proxy Object3D = js.context.THREE.Object3D;
final js.Proxy Particle = js.context.THREE.Particle;
final js.Proxy PlaneGeometry = js.context.THREE.PlaneGeometry;
final js.Proxy MeshBasicMaterial = js.context.THREE.MeshBasicMaterial;
final js.Proxy Mesh = js.context.THREE.Mesh;
final js.Proxy ParticleBasicMaterial = js.context.THREE.ParticleBasicMaterial;
final js.Proxy CanvasRenderer = js.context.THREE.CanvasRenderer;
final js.Proxy PerspectiveCamera = js.context.THREE.PerspectiveCamera;
final js.Proxy Stats = js.context.Stats;

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

//final String AUDIO_FILE = '../songs/dubstep_bass';
// const String AUDIO_FILE = '../songs/tonetest';
const String AUDIO_FILE = '../songs/deux_hirondelles';
final List<String> AUDIO_CODECS = [ 'ogg', 'mp3' ];

const
  PARTICLE_COUNT    = 128,
  MAX_PARTICLE_SIZE = 12,
  MIN_PARTICLE_SIZE = 2,
  GROWTH_RATE       = 5,
  DECAY_RATE        = 0.5,

  BEAM_RATE         = 0.5,
  BEAM_COUNT        = 12;

final
  GROWTH_VECTOR = new js.Proxy(Vector3, GROWTH_RATE, GROWTH_RATE, GROWTH_RATE ),
  DECAY_VECTOR  = new js.Proxy(Vector3, DECAY_RATE, DECAY_RATE, DECAY_RATE ),
  beamGroup     = new js.Proxy(Object3D),
  colors        = [ 0xaaee22, 0x04dbe5, 0xff0077, 0xffb412, 0xf6c83d ];

void main() {

    Dancer.setOptions({
      'flashSWF' : 'packages/dancer/src/js/soundmanager2.swf',
      'flashJS ' : 'packages/dancer/src/js/soundmanager2.js'
    });

    initScene();

    final Dancer dancer = new Dancer();
    final Kick kick = dancer.createKick( new KickOptions()
        ..onKick = (num mag) {
          final particles = group.children;
          var i;
          if ( particles[ 0 ].scale.x > MAX_PARTICLE_SIZE ) {
            decay( mag);
          } else {
            for ( int i = PARTICLE_COUNT - 1; i >= 0; i-- ) {
              particles[ i ].scale.addSelf( GROWTH_VECTOR );
            }
          }
          if ( !beamGroup.children[ 0 ].visible ) {
            for ( int i = BEAM_COUNT - 1; i >= 0; i--) {
              beamGroup.children[ i ].visible = true;
            }
          }
        }
        ..offKick = decay );
    
    dancer.onceAt( 0.0, () {
      kick.on();
    }).onceAt( 8.2, () {
      scene.add( beamGroup );
    }).after( 8.2, () {
      beamGroup.rotation.x += BEAM_RATE;
      beamGroup.rotation.y += BEAM_RATE;
    }).onceAt( 50.0, () {
      changeParticleMat( 'white' );
    }).onceAt( 66.5, () {
      changeParticleMat( 'pink' );
    }).onceAt( 75.0, () {
      changeParticleMat();
    }).load({ 'src': AUDIO_FILE, 'codecs': AUDIO_CODECS});

    final String supported = Dancer.isSupported();
    if ( supported != null && supported.isNotEmpty) {
      loaded(dancer);
    }
    if (!dancer.isLoaded()) {
      dancer.bind( 'loaded', () => loaded(dancer) );
    } else {
      loaded(dancer);
    }

    // Uncomment below and add "<canvas id='fft'>..." in html
    // if you want FFT vasualizer.
    // 
    // final CanvasElement fft = document.getElementById( 'fft' );
    // final CanvasRenderingContext2D ctx = fft.context2D;
    // dancer.fft( fft );
    
    on();
}



void on () {
  final math.Random random = new math.Random();

  for ( int i = PARTICLE_COUNT - 1; i >= 0; i--) {
    var particle = new js.Proxy(Particle,  newParticleMat() );
    particle.position.x = random.nextDouble() * 2000 - 1000;
    particle.position.y = random.nextDouble() * 2000 - 1000;
    particle.position.z = random.nextDouble() * 2000 - 1000;
    particle.scale.x = particle.scale.y = random.nextDouble() * 10 + 5;
    group.add( particle );
  }
  scene.add( group );

  var
    beamGeometry = new js.Proxy(PlaneGeometry, 5000, 50, 1, 1 ),
    beamMaterial, beam;

  for ( int i = BEAM_COUNT - 1; i >= 0; i--) {
    beamMaterial = new js.Proxy(MeshBasicMaterial, js.map({
      'opacity': 0.5,
      'blending': THREE.AdditiveBlending,
      'depthTest': false,
      'color': colors[ ( random.nextDouble() * 5 ).toInt()]
    }));
    beam = new js.Proxy( Mesh, beamGeometry, beamMaterial );
    beam.doubleSided = true;
    beam.rotation.x = random.nextDouble() * math.PI;
    beam.rotation.y = random.nextDouble() * math.PI;
    beam.rotation.z = random.nextDouble() * math.PI;
    beamGroup.add( beam );
  }
}

void decay ( num mag) {
  final particles = group.children;

  if ( beamGroup.children[ 0 ].visible ) {
    for ( int i = BEAM_COUNT - 1; i >= 0; i--) {
      beamGroup.children[ i ].visible = false;
    }
  }

  for ( int i = PARTICLE_COUNT - 1; i >= 0; i--) {
    var particle_scale = particles[i].scale;
    if ( particle_scale.x - DECAY_RATE > MIN_PARTICLE_SIZE ) {
      particle_scale.subSelf( DECAY_VECTOR );
    }
  }
}

void changeParticleMat ( [String color] ) {
  final particles = group.children;

  var mat = newParticleMat( color );
  for ( int i = PARTICLE_COUNT - 1; i >= 0; i--) {
    if ( color != null) {
      mat = newParticleMat(); // ParticleBasicMaterial
    }
    particles[ i ].material = mat;
  }
}

js.Proxy newParticleMat( [String color] ) {
  var
    sprites = [ 'pink', 'orange', 'yellow', 'blue', 'green' ],
    sprite = color != null ? color : sprites[ ( new math.Random().nextDouble() * 5 ).toInt()];

  return new js.Proxy(ParticleBasicMaterial, js.map({
    'blending': THREE.AdditiveBlending,
    'size': MIN_PARTICLE_SIZE,
    'map': THREE.ImageUtils.loadTexture('images/particle_' + sprite + '.png'),
    'vertexColor': 0xFFFFFF
  }));
}

// Expose these for the demo
var rotateSpeed = 1;
var scene = new js.Proxy(Scene);
var group = new js.Proxy(Object3D);
var camera;

initScene() {
  var container;
  var renderer, particle;
  var mouseX = 0, mouseY = 0;

  var stats = new js.Proxy( Stats);
  stats.domElement.id = 'stats';
  document.getElementById('info').insertBefore( stats.domElement, document.getElementById('togglefft') );

  var windowHalfX = window.innerWidth / 2;
  var windowHalfY = window.innerHeight / 2;

  var init =() {
    container = document.createElement( 'div' );
    document.body.append( container );
    camera = new js.Proxy(PerspectiveCamera, 75, window.innerWidth / window.innerHeight, 1, 3000 );
    camera.position.z = 1000;

    scene.add( camera );
    scene.add( group );

    renderer = new js.Proxy(CanvasRenderer);
    renderer.setSize( window.innerWidth, window.innerHeight );
    container.append( renderer.domElement );

    var onDocumentMouseMove = ( MouseEvent event ) {
      mouseX = event.client.x - windowHalfX;
      mouseY = event.client.y - windowHalfY;
    };

    var onDocumentTouch = ( TouchEvent event ) {
      if ( event.touches.length == 1 ) {
        event.preventDefault();
        mouseX = event.touches[ 0 ].page.x - windowHalfX;
        mouseY = event.touches[ 0 ].page.y - windowHalfY;
      }
    };

    document.addEventListener( 'mousemove', onDocumentMouseMove, false );
    document.addEventListener( 'touchstart', onDocumentTouch, false );
    document.addEventListener( 'touchmove', onDocumentTouch, false );
  };

  var t = 0;
  var render = () {
    camera.position.x = math.sin(t * 0.005 * rotateSpeed) * 1000;
    camera.position.z = math.cos(t * 0.005 * rotateSpeed) * 1000;
    camera.position.y += ( - mouseY - camera.position.y ) * 0.01;
    camera.lookAt( scene.position );
    t++;
    renderer.render( scene, camera );
  };

  var animate = ( var next_animate) {
    js.context.requestAnimationFrame( ( frame) => next_animate(next_animate) );
    render();
    stats.update();
  };

  init();
  animate( animate);

}

