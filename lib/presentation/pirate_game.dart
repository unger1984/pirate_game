import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pirate/presentation/blocs/sound_bloc.dart';
import 'package:pirate/presentation/screens/start_screen.dart';

class PirateGame extends FlameGame with HasTappables {
  final SoundBLoC soundBLoC;
  final startScreen = StartScreen();
  late final FlameBlocProvider<SoundBLoC, SoundState> blocProvider;

  PirateGame({required this.soundBLoC});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.zoom = 1;
    camera.viewport = DefaultViewport();

    blocProvider = FlameBlocProvider<SoundBLoC, SoundState>.value(value: soundBLoC);

    await add(blocProvider);

    await blocProvider.add(startScreen);

    // Future.delayed(Duration(seconds: 10), () {
    //   blocProvider.remove(startScreen);
    // });
  }

  Future<void> start() async {
    blocProvider.remove(startScreen);
  }
}
