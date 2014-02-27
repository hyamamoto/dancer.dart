part of dancer;

typedef void DancerCallback(Dancer dancer);
typedef void DancerBindCallback();
  
class Dancer implements js.Serializable<js.Proxy> {
  final js.Proxy _proxy;
  js.Proxy toJs() => _proxy;
  
  Dancer(String path) : this._(new js.Proxy(js.context.Dancer, path));
  Dancer._(this._proxy);

  static Map<String, DancerAdapter> get adapters => 
      jsw.JsObjectToMapAdapter.cast( js.context.Dancer.adapters, 
          new jsw.Translater<DancerAdapter>(
              (dynamic js_v) => js_v != null ? new DancerAdapter._(js_v): null,
              (DancerAdapter da_v) => da_v != null ? da_v.toJs(): null));

  set audioAdapter(DancerAdapter audioAdapter) => _proxy.audioAdapter = audioAdapter.toJs();
  DancerAdapter get audioAdapter => _proxy.audioAdapter != null ? new DancerAdapter._(_proxy.audioAdapter): null;

  // set events(Map<String, dynamic> events) => _proxy.events = js.map(events);
  Map<String, dynamic> get events => jsw.JsObjectToMapAdapter.cast(_proxy.events);

  // set sections(sections) => _proxy.sections = js.array(sections);
  get sections => jsw.JsObjectToListAdapter.cast(_proxy.sections);

  Beat createBeat(Float32List freq, double threshold, double decay, BeatOnOffCallback onBeat, BeatOnOffCallback offBeat)
      => _proxy.createBeat(
          js.array(freq), threshold, decay, onBeat, offBeat);

  void bind(String name, DancerBindCallback callback) => _proxy.bind( name, callback);

  void unbind(String name) => _proxy.unbind(name);

  void trigger(String name) => _proxy.trigger(name);

  double getTime() => _proxy.getTime();

  double getFrequency(var freq, [endFreq]) => _proxy.getFrequency(freq, endFreq);

  Float32List getSpectrum() => _proxy.getSpectrum();

  bool isLoaded() => _proxy.isLoaded;

  bool isPlaying() => _proxy.isPlaying;

  Dancer after(num time, DancerCallback callback) {
    _proxy.after(time, _toJsDancerCallback(callback));
    return this;
  }

  Dancer before(num time, DancerCallback callback) {
    _proxy.before(time, _toJsDancerCallback(callback));
    return this;
  }

  Dancer between(num startTime, num endTime, DancerCallback callback) {
    _proxy.between(startTime, endTime, _toJsDancerCallback(callback));
    return this;
  }

  Dancer onceAt(num time, DancerCallback callback) {
    _proxy.onceAt(time, _toJsDancerCallback(callback));
    return this;
  }

  static void addPlugin( String name, dynamic fn) => js.context.Dancer.addPlugin( name, fn);
  
  dynamic _toJsDancerCallback(DancerCallback callback) => (dynamic dancer) => callback(new Dancer._(dancer));

}
