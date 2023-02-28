import 'package:get_it/get_it.dart';
import 'package:pirate/data/datasources/settings_source_secure_storage.dart';
import 'package:pirate/data/repositories/settings_repository_impl.dart';
import 'package:pirate/domain/datasources/settings_source.dart';
import 'package:pirate/domain/repositories/settings_repository.dart';

Future<void> setupGetIt() async {
  final settingsSource = SettingsSourceSecureStorage();
  await settingsSource.initialize;

  GetIt.I.registerSingleton<SettingsSource>(settingsSource);
  GetIt.I.registerSingleton<SettingsRepository>(SettingsRepositoryImpl(settingsDatasource: settingsSource));
}
