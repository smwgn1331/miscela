import 'package:get_it/get_it.dart';

import 'config/http.dart';
import 'services/navigation.dart';
import 'services/storage.dart';

class Miscela {
  static GetIt svc = GetIt.I;

  static registerServices({required String httpBaseUrl}) {
    svc.registerSingleton<HttpConfig>(HttpConfig(httpBaseUrl));
    svc.registerSingleton<Storage>(Storage());
    svc.registerSingleton<Navigation>(Navigation());
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
