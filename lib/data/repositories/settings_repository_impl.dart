import 'package:pirate/domain/datasources/settings_source.dart';
import 'package:pirate/domain/repositories/settings_repository.dart';

/// Реализация репозитория для авторизации.
class SettingsRepositoryImpl extends SettingsRepository {
  final SettingsSource _settingsDatasource;
  late String? _locale;

  SettingsRepositoryImpl({required SettingsSource settingsDatasource})
      : assert(settingsDatasource.isDone, 'SettingsDatasource not initialized'),
        _settingsDatasource = settingsDatasource {
    _locale = _settingsDatasource.getString('locale');
  }

  @override
  String? get locale => _locale;

  @override
  set locale(String? value) {
    _locale = value;
    if (value != null) {
      _settingsDatasource.setString('locale', value);
    } else {
      _settingsDatasource.remove('locale');
    }
  }
}
