import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:pirate/domain/app_bloc_observer.dart';
import 'package:pirate/presentation/app.dart';
import 'package:pirate/utils/di.dart';
import 'package:pirate/utils/log.dart';

Future<void> main() async {
  final log = Logger('Main');
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortraitUpOnly();
  // await DesktopWindow.setMinWindowSize(const Size(1080, 1920));
  // await DesktopWindow.setMaxWindowSize(const Size(1080, 1920));
  // await DesktopWindow.setWindowSize(const Size(1080, 1920));

  await dotenv.load(fileName: ".env");
  await setupGetIt();
  setupLogging();

  runZonedGuarded<void>(
    () {
      Bloc.observer = AppBlocObserver.instance();
      Bloc.transformer = bloc_concurrency.sequential<Object?>();
      runApp(const App());
    },
    (err, stackTrace) => log.shout('Unhandled exception', err, stackTrace),
  );
}
