import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final FlutterSecureStorage _skull = const FlutterSecureStorage();

  Future get(String key) async {
    return await _skull.read(key: key);
  }

  Future put(String key, dynamic value) async {
    await _skull.write(key: key, value: value);
    return await _skull.read(key: key);
  }
}
