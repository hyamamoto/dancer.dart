part of dancer;


typedef void BeatOnOffCallback(Dancer dancer, double magnitude);

class BeatOptions implements js.Serializable<js.Proxy> {
  final js.Proxy _proxy;
  js.Proxy toJs() => _proxy;

  BeatOptions() : this._(new js.Proxy(js.context.Object));
  BeatOptions._(this._proxy);

  set frequency(Float32List frequency) => js.array(_proxy.frequency = frequency);
  set threshold(double threshold) => _proxy.threshold = threshold;
  set decay(double decay) => _proxy.decay = decay;
  set onBeat(BeatOnOffCallback onBeat) => _proxy.onBeat = onBeat;
  set offBeat(BeatOnOffCallback offBeat) => _proxy.offBeat = offBeat;
}

class Beat implements js.Serializable<js.Proxy> {

  final js.Proxy _proxy;
  js.Proxy toJs() => _proxy;
  
  // XXX: options is a json
  Beat( Dancer dancer, [BeatOptions options]) : this._(new js.Proxy(js.context.Dancer.Beat, dancer, options));
  Beat._(this._proxy);
  
  Dancer get dancer => _proxy.dancer;
  Float32List get frequency => jsw.JsObjectToArrayList.cast(_proxy.frequency); // default [0, 10]
  double get threshold => _proxy.threshold; // default 0.3
  double get decay => _proxy.decay; // default 0.02
  BeatOnOffCallback get onBeat => _proxy.onBeat;
  BeatOnOffCallback get offBeat => _proxy.offBeat;
  bool get isOn => _proxy.isOn; // default false
  double get currentThreshold => _proxy.currentThreshold;

  void on() => _proxy.on();
  void off() => _proxy.off();

  double maxAmplitude(List<double> fft, List<double> frequency) => _proxy.maxAmplitude(fft, frequency);
}
