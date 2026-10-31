import 'package:get_storage/get_storage.dart';

class TokenStorage {
  TokenStorage([GetStorage? box]) : _box = box ?? GetStorage();

  static const _key = 'auth_token';
  final GetStorage _box;

  String? read() => _box.read<String>(_key);

  Future<void> write(String token) => _box.write(_key, token);

  Future<void> clear() => _box.remove(_key);
}
