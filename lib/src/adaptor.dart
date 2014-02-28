part of dancer;

class DancerAdapter implements js.Serializable<js.Proxy> {
  final js.Proxy _proxy;
  js.Proxy toJs() => _proxy;

  DancerAdapter(Dancer dancer) : this._(new js.Proxy(js.context.Dancer.adapters.webkit, dancer));
  DancerAdapter._(this._proxy);

  Dancer get dancer => new Dancer._(_proxy.dancer);

  dynamic get audio => _proxy.audio; // Audio, SMSound, etc...
  
  dynamic get context => _proxy.audio; // AudioContext, webkitAudioContext, null, etc...

  String get path => _proxy.path;

  num get progress => _proxy.progress;

  set isLoaded(bool isLoaded) => _proxy.isLoaded = isLoaded;
  
  bool get isLoaded => _proxy.isLoaded;

  set isPlaying(bool isPlaying) => _proxy.isPlaying = isPlaying;
  
  bool get isPlaying => _proxy.isPlaying;

  /// `source` can be either an Audio element, if supported, or an object
  /// either way, the path is stored in the `src` property
  /// @return Returns audio property value if already loaded.
  dynamic load( dynamic source) => _proxy.load( source);

  void play() => _proxy.play();
  
  void pause() => _proxy.pause();
  
  void update( e) { _proxy.update( e);}

  void setVolume(num volume) => _proxy.setVolume(volume);

  num getVolume() => _proxy.getVolume();

  num getProgress() => _proxy.getProgress();

  Float32List getWaveform() => _proxy.getWaveform();
  
  Float32List getSpectrum() => _proxy.getSpectrum();
  
  num getTime() => _proxy.getTime();

  // #
  // # These Other properties appear depending on adaptor's implementation. 
  // #
  // fbLength;
  // channels;
  // rate;
  // fft;
  // MediaElementSource source;
  // gain;
  // proc;
  // wave_L;
  // wave_R;
  // spectrum;
}

