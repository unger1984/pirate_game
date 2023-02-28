/// Интерфейс репозитория настроек.
abstract class SettingsRepository {
  /// Данные по авторизации.
  String? get locale;
  set locale(String? value);
}
