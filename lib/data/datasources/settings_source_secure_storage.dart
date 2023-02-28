import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pirate/domain/datasources/settings_source.dart';

/// Реализация источника данных настроек через [FlutterSecureStorage].
class SettingsSourceSecureStorage extends SettingsSource {
  final Map<String, String> _prefs = {};
  final _storage = const FlutterSecureStorage();
  late Future<void> _initialize;
  bool _isDone = false;

  /// После вызова конструктора, обязательно проверить статус initialize.
  SettingsSourceSecureStorage() {
    _initialize = _init();
  }

  /// Первоначальное считываение данных.
  Future<void> _init() async {
    _prefs.clear();
    _prefs.addAll(await _storage.readAll());
    _isDone = true;
  }

  @override
  Future<void> get initialize => _initialize;

  @override
  bool get isDone => _isDone;

  @override
  // Не ругайся
  // ignore: no-object-declaration
  Object? get(String key) {
    return _prefs.containsKey(key) ? _prefs[key] : null;
  }

  @override
  String? getString(String key) {
    return _prefs.containsKey(key) ? _prefs[key] : null;
  }

  @override
  bool? getBool(String key) {
    return _prefs.containsKey(key) ? _prefs[key] == 'true' : null;
  }

  @override
  double? getDouble(String key) {
    return _prefs.containsKey(key) ? double.tryParse(_prefs[key] ?? 'null') : null;
  }

  @override
  int? getInt(String key) {
    return _prefs.containsKey(key) ? int.tryParse(_prefs[key] ?? 'null') : null;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _prefs[key] = value ? 'true' : 'false';
    await _storage.write(key: key, value: _prefs[key]);

    return true;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _prefs[key] = value.toString();
    await _storage.write(key: key, value: _prefs[key]);

    return true;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _prefs[key] = value.toString();
    await _storage.write(key: key, value: _prefs[key]);

    return true;
  }

  @override
  Future<bool> setString(String key, String value) async {
    _prefs[key] = value;
    await _storage.write(key: key, value: _prefs[key]);

    return true;
  }

  @override
  Future<bool> remove(String key) async {
    await _storage.delete(key: key);
    final res = _prefs.remove(key);

    return res != null;
  }

  @override
  Future<bool> clear() async {
    await _storage.deleteAll();
    _prefs.clear();

    return true;
  }
}
