import 'dart:html';
import 'dart:async';
import 'dart:math' as math;

import 'package:js/js.dart' as js;

import 'package:dancer/dancer.dart';

const String AUDIO_FILE = '../songs/deux_hirondelles';
final List<String> AUDIO_CODECS = [ 'ogg', 'mp3' ];
final int ROTATE_SPEED = 1;

const
  PARTICLE_COUNT    = 192,
  MAX_PARTICLE_SIZE = 12,
  MIN_PARTICLE_SIZE = 2,
  GROWTH_RATE       = 5,
  DECAY_RATE        = 0.5,
  BEAM_RATE         = 0.5,
  BEAM_COUNT        = 18;

final
  GROWTH_VECTOR   = new js.Proxy(Vector3, GROWTH_RATE, GROWTH_RATE, GROWTH_RATE ),
  DECAY_VECTOR  = new js.Proxy(Vector3, DECAY_RATE, DECAY_RATE, DECAY_RATE ),
  beamGroup     = new js.Proxy(Object3D),
  colors        = [ 0xaaee22, 0x04dbe5, 0xff0077, 0xffb412, 0xf6c83d ],
  random = new math.Random(),
  sprites = [ 'pink', 'orange', 'yellow', 'blue', 'green' ];

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

    // Flash audio fallback support
    Dancer.setOptions({
      'flashSWF' : 'packages/dancer/src/js/soundmanager2.swf',
      'flashJS ' : 'packages/dancer/src/js/soundmanager2.js'
    });

    // Initialize three.js scene
    initScene();

    // Create a Dancer instance.
    final Dancer dancer = new Dancer();

    // Add a Kick for the star tinkering.
    final js.Proxy particles = group.children;
    final Kick kick = dancer.createKick( new KickOptions()
        ..onKick = ( mag) {
          int i;
          if ( particles[ 0 ].scale.x > MAX_PARTICLE_SIZE ) {
            decay( mag);
          } else {
            for ( i = PARTICLE_COUNT - 1; i >= 0; i-- ) {
              particles[ i ].scale.addSelf( GROWTH_VECTOR );
            }
          }
          if ( !beamGroup.children[ 0 ].visible ) {
            for ( i = BEAM_COUNT - 1; i >= 0; i--) {
              beamGroup.children[ i ].visible = true;
            }
          }
        }
        ..offKick = decay );
    
    // Schedule time events then load an audio file.
    dancer.onceAt( 0, () {
      kick.on();
    }).onceAt( 8.2, () {
      scene.add( beamGroup );
    }).after( 8.2, () {
      beamGroup.rotation.x += BEAM_RATE;
      beamGroup.rotation.y += BEAM_RATE;
    }).onceAt( 50, () {
      changeParticleMat( 'white' );
    }).onceAt( 66.5, () {
      changeParticleMat( 'pink' );
    }).onceAt( 75, () {
      changeParticleMatRandom();
    });
    
    // Load an audio
    dancer.load({ 'src': AUDIO_FILE, 'codecs': AUDIO_CODECS});

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

    // Uncomment below and add "<canvas id='fft'>..." in html
    // if you want FFT vasualizer.
    // 
    // final CanvasElement fft = document.getElementById( 'fft' );
    // final CanvasRenderingContext2D ctx = fft.context2D;
    // dancer.fft( fft );
    
    on();
}

void on () {

  for ( int i = PARTICLE_COUNT - 1; i >= 0; i--) {
    final js.Proxy particle = new js.Proxy(Particle,  newParticleMat( sprites[ random.nextInt(5)]) )
      ..position.x = random.nextInt( 2000) - 1000
      ..position.y = random.nextInt( 2000) - 1000
      ..position.z = random.nextInt( 2000) - 1000
      ..scale.x = random.nextInt( 10) + 5;
    particle.scale.y = particle.scale.x;
    group.add( particle );
  }
  scene.add( group );

  final beamGeometry = new js.Proxy(PlaneGeometry, 5000, 50, 1, 1 );

  for ( int i = BEAM_COUNT - 1; i >= 0; i--) {
    final beamMaterial = new js.Proxy(MeshBasicMaterial, js.map({
      'opacity': 0.5,
      'blending': THREE.AdditiveBlending,
      'depthTest': false,
      'color': colors[ random.nextInt( 5)]
    }));

    final beam = new js.Proxy( Mesh, beamGeometry, beamMaterial )
      ..doubleSided = true
      ..rotation.x = random.nextDouble() * math.PI
      ..rotation.y = random.nextDouble() * math.PI
      ..rotation.z = random.nextDouble() * math.PI;
    beamGroup.add( beam );
  }
}

void decay ( mag) {
  final js.Proxy beanChildren = beamGroup.children;
  if ( beanChildren[ 0 ].visible ) {
    for ( int i = BEAM_COUNT - 1; i >= 0; i--) {
      beanChildren[ i ].visible = false;
    }
  }

  final js.Proxy particles = group.children;
  for ( int i = PARTICLE_COUNT - 1; i >= 0; i--) {
    final js.Proxy particle_scale = particles[i].scale;
    if ( particle_scale.x > MIN_PARTICLE_SIZE + DECAY_RATE) {
      particle_scale.subSelf( DECAY_VECTOR );
    }
  }
}

void changeParticleMatRandom () {
  final js.Proxy particles = group.children;
  for ( int i = PARTICLE_COUNT - 1; i >= 0; i--) {
    final String sprite = sprites[ random.nextInt(5)];
    particles[i].material = newParticleMat( sprite); // ParticleBasicMaterial
  }
}

void changeParticleMat ( String sprite) {
  final js.Proxy particles = group.children;
  final mat = newParticleMat( sprite );
  for ( int i = PARTICLE_COUNT - 1; i >= 0; i--) {
    particles[i].material = mat;
  }
}

js.Proxy newParticleMat( String sprite) {
  return new js.Proxy(ParticleBasicMaterial, js.map({
    'blending': THREE.AdditiveBlending,
    'size': MIN_PARTICLE_SIZE,
    'map': THREE.ImageUtils.loadTexture('images/particle_' + sprite + '.png'),
    'vertexColor': 0xFFFFFF
  }));
}

// Exproted variables for main() from initScene()
final
  scene = new js.Proxy(Scene),
  group = new js.Proxy(Object3D);
var camera;

initScene() {
  DivElement container;
  js.Proxy renderer;
  int mouseX = 0, mouseY = 0;

  final stats = new js.Proxy( Stats);
  stats.domElement.id = 'stats';
  document.getElementById('info').insertBefore( stats.domElement, document.getElementById('togglefft') );

  var init =() {
    final windowHalfX = window.innerWidth / 2;
    final windowHalfY = window.innerHeight / 2;

    container = document.createElement( 'div' );
    document.body.append( container );
    camera = new js.Proxy(PerspectiveCamera, 75, window.innerWidth / window.innerHeight, 1, 3000 );
    camera.position.z = 1000;

    scene.add( camera );
    scene.add( group );

    renderer = new js.Proxy(CanvasRenderer);
    renderer.setSize( window.innerWidth, window.innerHeight );
    container.append( renderer.domElement );

    final Function onDocumentMouseMove = ( MouseEvent event ) {
      mouseX = event.client.x - windowHalfX;
      mouseY = event.client.y - windowHalfY;
    };

    final Function onDocumentTouch = ( TouchEvent event ) {
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

  int t = 0;
  Function animate;
  animate = (num frame) {
    js.context.requestAnimationFrame( animate );

    camera
      ..position.x = math.sin(t * 0.005 * ROTATE_SPEED) * 1000
      ..position.z = math.cos(t * 0.005 * ROTATE_SPEED) * 1000
      ..position.y += ( - mouseY - camera.position.y ) * 0.01
      ..lookAt( scene.position );
    t++;

    renderer.render( scene, camera );

    stats.update();
  };

  init();
  animate( 0);
}
