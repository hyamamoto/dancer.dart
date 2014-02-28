part of dancer;

typedef void KickOnOffCallback(num magnitude);

class KickOptions implements js.Serializable<js.Proxy> {
  final js.Proxy _proxy;
  js.Proxy toJs() => _proxy;

  KickOptions() : this._(new js.Proxy(js.context.Object));
  KickOptions._(this._proxy);

  set frequency(Float32List frequency) => js.array(_proxy.frequency = frequency);
  set threshold(num threshold) => _proxy.threshold = threshold;
  set decay(num decay) => _proxy.decay = decay;
  set onKick(KickOnOffCallback onKick) => _proxy.onKick = onKick;
  set offKick(KickOnOffCallback offKick) => _proxy.offKick = offKick;
}

class Kick implements js.Serializable<js.Proxy> {

  final js.Proxy _proxy;
  js.Proxy toJs() => _proxy;
  
  Kick( Dancer dancer, [KickOptions options]) : this._( options == null ? 
            new js.Proxy(js.context.Dancer.Kick, dancer.toJs()):
              new js.Proxy(js.context.Dancer.Kick, dancer.toJs(), options.toJs()));
  Kick._(this._proxy);
  
  Dancer get dancer => _proxy.dancer;
  Float32List get frequency => jsw.JsObjectToArrayList.cast(_proxy.frequency); // default [0, 10]
  double get threshold => _proxy.threshold; // default 0.3
  double get decay => _proxy.decay; // default 0.02
  KickOnOffCallback get onKick => _proxy.onKick;
  KickOnOffCallback get offKick => _proxy.offKick;
  bool get isOn => _proxy.isOn; // default false
  double get currentThreshold => _proxy.currentThreshold;

  /// Turns on the kick instance's callbacks and detections
  Kick on() {
    _proxy.on();
    return this;
  }
  
  /// Turns off the kick instance's callbacks and detections
  Kick off() {
    _proxy.off();
    return this;
  }

  /// Can pass in an object literal with the 5 kick options, similar to creating a new kick option
  void set( KickOptions options) => _proxy.set( options.toJs());

  void onUpdate() => _proxy.onUpdate();

  num maxAmplitude(List<double> fft, List<double> frequency) => _proxy.maxAmplitude(fft, frequency);
}
