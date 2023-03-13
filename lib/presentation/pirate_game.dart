import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pirate/domain/entities/target_entity.dart';
import 'package:pirate/presentation/blocs/sound_bloc.dart';
import 'package:pirate/presentation/screens/main_screen.dart';
import 'package:pirate/presentation/screens/map_screen.dart';
import 'package:pirate/presentation/screens/start_screen.dart';

class PirateGame extends FlameGame with HasTappableComponents, HasDraggableComponents {
  final SoundBLoC soundBLoC;
  final startScreen = StartScreen();
  final mainScreen = MainScreen();
  final mapScreen = MapScreen();
  late final FlameBlocProvider<SoundBLoC, SoundState> blocProvider;

  PirateGame({required this.soundBLoC});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.zoom = 1;
    camera.viewport = DefaultViewport();
    // camera.viewport = FixedResolutionViewport(Vector2(1080,1920));

    blocProvider = FlameBlocProvider<SoundBLoC, SoundState>.value(value: soundBLoC);

    await add(blocProvider);
    await blocProvider.add(startScreen);
    // await blocProvider.add(mainScreen);
    // mainScreen.setLevel(const TargetEntity(
    //   type: TargetType.moves,
    //   limit: 2,
    //   ches1: TargetChestEntity(gem: 'red', total: 5),
    //   ches2: TargetChestEntity(gem: 'green', total: 5),
    //   ches3: TargetChestEntity(gem: 'blue', total: 5),
    //   star1: 15,
    //   star2: 20,
    //   star3: 30,
    // ));
  }

  void _clear() {
    if (blocProvider.children.contains(startScreen)) blocProvider.remove(startScreen);
    if (blocProvider.children.contains(mapScreen)) blocProvider.remove(mapScreen);
    if (blocProvider.children.contains(mainScreen)) blocProvider.remove(mainScreen);
  }

  Future<void> onStart() async {
    _clear();
    await blocProvider.add(mapScreen);
  }

  Future<void> goMain(TargetEntity targetConfig) async {
    _clear();
    await blocProvider.add(mainScreen);
    mainScreen.setLevel(targetConfig);
  }
}
