import 'package:pirate/domain/datasources/settings_source.dart';
import 'package:pirate/domain/repositories/settings_repository.dart';

/// Реализация репозитория для авторизации.
class SettingsRepositoryImpl extends SettingsRepository {
  final SettingsSource _settingsDatasource;
  late String? _locale;
  double _levelMusic = 1;
  double _levelSound = 1;

  SettingsRepositoryImpl({required SettingsSource settingsDatasource})
      : assert(settingsDatasource.isDone, 'SettingsDatasource not initialized'),
        _settingsDatasource = settingsDatasource {
    _locale = _settingsDatasource.getString('locale');
    _levelMusic = _settingsDatasource.getDouble('levelMusic') ?? 1;
    _levelSound = _settingsDatasource.getDouble('levelSound') ?? 1;
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

  @override
  double get levelMusic => _levelMusic;

  @override
  double get levelSound => _levelSound;

  @override
  set levelMusic(double value) {
    _levelMusic = value;
    _settingsDatasource.setDouble('levelMusic', value);
  }

  @override
  set levelSound(double value) {
    _levelSound = value;
    _settingsDatasource.setDouble('levelSound', value);
  }
}
