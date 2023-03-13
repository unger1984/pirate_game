import 'package:flame/components.dart';
import 'package:pirate/domain/entities/target_chest_entity.dart';
import 'package:pirate/domain/entities/target_entity.dart';
import 'package:pirate/presentation/components/map/map_component.dart';
import 'package:pirate/presentation/pirate_game.dart';

class MapScreen extends PositionComponent with HasGameRef<PirateGame> {
  late final MapComponent map;
  late final Sprite bgSprite;
  final targetConfig = const TargetEntity(
    type: TargetType.moves,
    limit: 2,
    ches1: TargetChestEntity(gem: 'red', total: 5),
    ches2: TargetChestEntity(gem: 'green', total: 5),
    ches3: TargetChestEntity(gem: 'blue', total: 5),
    star1: 15,
    star2: 20,
    star3: 30,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    map = MapComponent(onTapLevel: onTapLevel);
    await add(map);
    map.init(1);
  }

  void onTapLevel(int num) {
    // TODO загрузка уровня
    gameRef.goMain(targetConfig);
  }
}
