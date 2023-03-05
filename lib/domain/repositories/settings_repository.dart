/// Интерфейс репозитория настроек.
abstract class SettingsRepository {
  /// Данные по авторизации.
  String? get locale;
  set locale(String? value);

  double get levelMusic;
  double get levelSound;

  set levelMusic(double value);
  set levelSound(double value);
}
