/// Источник данных для настроек.
abstract class SettingsSource {
  /// Initialize async data provider.
  Future<void> get initialize;
  bool get isDone;

  // read Object from data provider
  // ignore: no-object-declaration
  Object? get(String key);

  // Read String from data provider.
  String? getString(String key);

  // Read int from data provider.
  int? getInt(String key);

  // Read double from data provider.
  double? getDouble(String key);

  // Read bool from data provider.
  bool? getBool(String key);

  // Save String to data provider.
  Future<bool> setString(String key, String value);

  // Save int to data provider.
  Future<bool> setInt(String key, int value);

  // Save double to data provider.
  Future<bool> setDouble(String key, double value);

  // Save bool to data provider.
  Future<bool> setBool(String key, bool value);

  // Remove from data provider by key.
  Future<bool> remove(String key);

  // Clear data provider.
  Future<bool> clear();
}
