part of dancer;

class FFTOptions implements js.Serializable<js.Proxy> {
  final js.Proxy _proxy;
  js.Proxy toJs() => _proxy;

  FFTOptions() : this._(new js.Proxy(js.context.Object));
  FFTOptions._(this._proxy);

  set width(num width) => _proxy.width = width;
  set spacing(num spacing) => _proxy.spacing = spacing;
  set count(num count) => _proxy.count = count;
  set fillStyle(String fillStyle) => _proxy.fillStyle = fillStyle;
}

class WaveformOptions implements js.Serializable<js.Proxy> {
  final js.Proxy _proxy;
  js.Proxy toJs() => _proxy;

  WaveformOptions() : this._(new js.Proxy(js.context.Object));
  WaveformOptions._(this._proxy);

  set width(num width) => _proxy.width = width;
  set spacing(num spacing) => _proxy.spacing = spacing;
  set count(num count) => _proxy.count = count;
  set strokeWidth(num strokeWidth) => _proxy.strokeWidth = strokeWidth;
  set strokeStyle(String strokeStyle) => _proxy.strokeStyle = strokeStyle;
}
