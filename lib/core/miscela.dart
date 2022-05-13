import 'package:get_it/get_it.dart';

import '../config/http.dart';
import '../services/navigation.dart';
import '../services/storage.dart';

class Miscela {
  static GetIt svc = GetIt.I;

  static requireNavigation() {
    svc.registerSingleton<Navigation>(Navigation());
  }

  static requireStorage() {
    svc.registerSingleton<Storage>(Storage());
  }

  static requireHttp(String baseUrl) {
    svc.registerSingleton<HttpConfig>(HttpConfig(baseUrl));
  }

  static push<T extends Object>(T service) {
    svc.registerSingleton<T>(service);
    return svc<T>();
  }

  static pop<T extends Object>() {
    if (svc.isRegistered<T>()) {
      svc.unregister<T>();
    }
  }
}
