import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:pirate/domain/repositories/settings_repository.dart';
import 'package:pirate/domain/usecases/locale_use_case.dart';
import 'package:pirate/generated/l10n.dart';
import 'package:pirate/presentation/blocs/locale_bloc.dart';

@immutable
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleBLoC>(
      create: (_) => LocaleBLoC(
        localeUseCase: LocaleUseCase(
          settingsRepository: GetIt.I<SettingsRepository>(),
        ),
      ),
      child: BlocBuilder<LocaleBLoC, LocaleState>(
        builder: (context, state) => state.map(
          loading: (_) => const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator()))),
          success: (st) => MaterialApp(
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: Locale.fromSubtags(languageCode: st.locale),
            supportedLocales: S.delegate.supportedLocales,
            onGenerateTitle: (context) => S.of(context).title,
            restorationScopeId: 'root',
            home: Scaffold(
              body: Center(
                child: Text(st.locale),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
