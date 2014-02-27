part of dancer;

class DancerAdapter implements js.Serializable<js.Proxy> {
  final js.Proxy _proxy;
  js.Proxy toJs() => _proxy;

  DancerAdapter(Dancer dancer) : this._(new js.Proxy(js.context.Dancer.adapters.webkit, dancer));
  DancerAdapter._(this._proxy);

  Dancer get dancer => new Dancer._(_proxy.dancer);

  set isLoaded(bool isLoaded) => _proxy.isLoaded = isLoaded;
  bool get isLoaded => _proxy.isLoaded;

  set isPlaying(bool isPlaying) => _proxy.isPlaying = isPlaying;
  bool get isPlaying => _proxy.isPlaying;

  /// @deprecated moz only
  dynamic get audio => _proxy.audio; // Audio
  
  /// @deprecated webkit only
  dynamic get context => _proxy.context; // AudioContext

  void load( String path , [callback]) => callback != null ? _proxy.load( path, callback) : _proxy.load( path);
  void play() => _proxy.play();
  void stop() => _proxy.stop();
  Float32List getSpectrum() => _proxy.getSpectrum();
  num getTime() => _proxy.getTime();
  
  void update( e) { _proxy.update( e);}
}
