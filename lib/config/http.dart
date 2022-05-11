class HttpConfig {
  final String httpBaseUrl;
  final int connectTimeout;
  final int receiveTimeout;

  HttpConfig(this.httpBaseUrl,
      {this.connectTimeout = 6000, this.receiveTimeout = 6000});
}
