part of dancer;

typedef void DancerCallback();
typedef void DancerBindCallback();
  
class Dancer implements js.Serializable<js.Proxy> {
  final js.Proxy _proxy;
  js.Proxy toJs() => _proxy;
  
  Dancer() : this._(new js.Proxy(js.context.Dancer));
  Dancer._(this._proxy);

  /// A property of the Dancer object to return a string of the current Dancer version
  static String get version => js.context.Dancer.version;

  static Map<String, DancerAdapter> get adapters => 
      jsw.JsObjectToMapAdapter.cast( js.context.Dancer.adapters, 
          new jsw.Translater<DancerAdapter>(
              (dynamic js_v) => js_v != null ? new DancerAdapter._(js_v): null,
              (DancerAdapter da_v) => da_v != null ? da_v.toJs(): null));

  set audioAdapter(DancerAdapter audioAdapter) => _proxy.audioAdapter = audioAdapter.toJs();

  DancerAdapter get audioAdapter => _proxy.audioAdapter != null ? new DancerAdapter._(_proxy.audioAdapter): null;

  Map<String, dynamic> get events => jsw.JsObjectToMapAdapter.cast(_proxy.events);

  List<dynamic> get sections => jsw.JsObjectToListAdapter.cast(_proxy.sections);

  /// Specifies the audio source for the dancer instance. 
  /// source is an map object with a 'src' property and an optional 'codecs' array. 
  /// if you specify a map object, the src property can either be a string 
  /// of the audio path, or a string of the audio path, without the file 
  /// extension, if you specify a codec array to work across multiple audio 
  /// implementations
  Dancer load( Map<String, dynamic> source) {
    _proxy.load( js.map(source));
    return this;
  }

  /// Specifies the audio source for the dancer instance. 
  /// source is an audio element.
  Dancer loadFromAudio( AudioElement source) {
    _proxy.load( source);
    return this;
  }

  /* Controls */
  
  /// Plays the audio and begins the dance.
  Dancer play() {
    _proxy.play();
    return this;
  }
  
  /// Pauses the madness.
  Dancer pause() {
    _proxy.pause();
    return this;
  }

  /// Sets the player's current volume.
  Dancer setVolume( num volume) {
    _proxy.setVolume( volume);
    return this;
  }

  /* Actions */

  /// Creates a new kick instance tied to the dancer instance, with an options object passed as an argument. Options listed below.
  /// <ul>
  /// <li><code>frequency</code> the frequency (element of the spectrum) to check for a spike. Can be a single frequency (number) or a range (2 element array) that uses the frequency with highest amplitude. Default: [ 0, 10 ]</li>
  /// <li><code>threshold</code> the minimum amplitude of the frequency range in order for a kick to occur. Default: 0.3</li>
  /// <li><code>decay</code> the rate that the previously registered kick's amplitude is reduced by on every frame. Default: 0.02</li>
  /// <li><code>onKick</code> the callback to be called when a kick is detected.</li>
  /// <li><code>offKick</code> the callback to be called when there is no kick on the current frame.</li>
  /// </ul>
  Kick createKick(KickOptions options) => new Kick( this, options);

  /// Subscribes a callback of name. Can call this method several times to bind several callbacks of the same name.
  Dancer bind(String name, DancerBindCallback callback) {
    _proxy.bind( name, callback);
    return this;
  }
  
  /// Unsubscribes all callbacks of name.
  Dancer unbind(String name) {
    _proxy.unbind(name);
    return this;
  }

  /// Calls all callbacks of name.
  Dancer trigger(String name) {
    _proxy.trigger(name);
    return this;
  }
  
  /* Getters */

  /// Returns a normalized value (0 to 1) of the current volume.
  num getVolume() => _proxy.getVolume();

  /// Returns the downloading progress as a float from 0 to 1.
  num getProgress() => _proxy.getProgress();

  /// Returns the current time.
  num getTime() => _proxy.getTime();

  /// Returns the magnitude of a frequency or average over a range of frequencies.
  num getFrequency(num freq, [num endFreq]) =>  
      endFreq == null ? _proxy.getFrequency( freq): _proxy.getFrequency( freq, endFreq);

  /// Returns the waveform data array (Float32Array(1024))
  Float32List getWaveform() => _proxy.getWaveform();

  /// Returns the frequency data array (Float32Array(512))
  Float32List getSpectrum() => _proxy.getSpectrum();

  /// Returns a boolean value for the dancer instance's song load state.
  bool isLoaded() {
    var loaded = _proxy.isLoaded();
    return loaded != null ? loaded: false;
  }

  /// Returns a boolean value indicating whether the dancer instance's song is currently playing or not.
  bool isPlaying() {
    var playing = _proxy.isPlaying();
    return playing != null ? playing: false;
  }

  /* Sections */
  
  /// Fires callback on every frame after time 'time'.
  Dancer after(num time, DancerCallback callback) {
    _proxy.after(time, callback);
    return this;
  }

  /// Fires callback on every frame before time 'time'.
  Dancer before(num time, DancerCallback callback) {
    _proxy.before(time, callback);
    return this;
  }

  /// Fires callback on every frame between time 'startTime' and 'endTime'.
  Dancer between(num startTime, num endTime, DancerCallback callback) {
    _proxy.between(startTime, endTime, callback);
    return this;
  }

  /// Fires callback once at time 'time'.
  Dancer onceAt(num time, DancerCallback callback) {
    _proxy.onceAt(time, callback);
    return this;
  }

  // dynamic _toJsDancerCallback(DancerCallback callback) => () => callback(this);

  /* Support */
  
  static Map<String, dynamic> get options => jsw.JsObjectToMapAdapter.cast(js.context.Dancer.options);

  /// Takes a set of key-value pairs in an object for options. Options below.
  /// <ul>
  /// <li><code>flashSWF</code> The path to soundmanager2.swf. Required for flash fallback.</li>
  /// <li><codeflashJS</code> The path to soundmanager2.js. Required for flash fallback.</li>
  /// </ul>
  static void setOptions(Map<String, dynamic> options) => js.context.Dancer.setOptions(js.map( options));

  /// Returns a string of webaudio, audiodata or flash indicating level of support. Returns an empty string if the browser doesn't support any of the methods. Can also return null when browser does not support typed arrays.
  static String isSupported() => js.context.Dancer.isSupported();

  /// Returns either true or false indicating whether the browser supports playing back audio of type type, which can be a string of 'mp3', 'ogg', 'wav', or 'aac'.
  static bool canPlay( type) => js.context.Dancer.canPlay(type);

  /// Registers a plugin of name with initiation function fn -- described in more detail below
  static void addPlugin( String name, dynamic fn) => js.context.Dancer.addPlugin( name, fn);

  // Browser detection is lame, but Safari 6 has Web Audio API,
  // but does not support processing audio from a Media Element Source
  // https://gist.github.com/3265344
  static bool isUnsupportedSafari() => js.context.Dancer.isUnsupportedSafari();
  
  /* Plugins */
  
  Dancer fft( CanvasElement canvasEl, [FFTOptions options]) {
    if (options != null) 
      _proxy.fft( canvasEl, options.toJs());
    else
      _proxy.fft( canvasEl);
    return this;
  }

  Dancer waveform( CanvasElement canvasEl, [WaveformOptions options]) {
    if (options != null) 
      _proxy.waveform( canvasEl, options.toJs());
    else
      _proxy.waveform( canvasEl);
    return this;
  }
}

