import 'package:pirate/domain/repositories/settings_repository.dart';
import 'package:pirate/utils/syslocale/syslocale.dart';

class LocaleUseCase {
  final SettingsRepository _settingsRepository;

  const LocaleUseCase({required SettingsRepository settingsRepository}) : _settingsRepository = settingsRepository;

  Future<String> getLocale() async {
    String? locale = _settingsRepository.locale;
    locale ??= (await findSystemLocale()).substring(0, 2);

    return locale;
  }

  void setLocale(String? locale) {
    _settingsRepository.locale = locale;
  }
}
