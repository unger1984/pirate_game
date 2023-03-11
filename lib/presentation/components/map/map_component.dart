import 'package:flame/components.dart';
import 'package:pirate/presentation/components/map/island_component.dart';
import 'package:pirate/presentation/components/map/level_component.dart';
import 'package:pirate/presentation/pirate_game.dart';
import 'package:pirate/utils/const.dart';

class MapComponent extends SpriteComponent with HasGameRef<PirateGame> {
  Sprite? spriteBg;
  final void Function(int num) onTapLevel;
  final SpriteComponent palm = SpriteComponent();
  final island1 = IslandComponent(1);
  final island2 = IslandComponent(2);
  final island3 = IslandComponent(5);
  final island4 = IslandComponent(3);
  final island5 = IslandComponent(3);
  final island6 = IslandComponent(6);
  final island7 = IslandComponent(7);
  final island8 = IslandComponent(8);
  final levels = <LevelComponent>[
    LevelComponent(),
    LevelComponent(),
    LevelComponent(),
    LevelComponent(),
    LevelComponent(),
    LevelComponent(),
    LevelComponent(),
    LevelComponent(),
    LevelComponent(),
    LevelComponent(),
  ];

  MapComponent({required this.onTapLevel});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('jpg/bg_map.jpg');
    final sp = sprite;
    if (sp != null) {
      size = sp.srcSize;
    }

    await add(island8);
    island8.position = Vector2(size.x - island8.scaledSize.x, 0);
    await add(island7);
    await add(island6);
    island6.position = Vector2(size.x - island6.scaledSize.x, 200);
    await add(island5);
    island5.position = Vector2(size.x - island5.scaledSize.x, 1000);
    await add(island4);
    island4.position = Vector2(size.x - island4.scaledSize.x - 200, 1100);
    await add(island3);
    island3.position = Vector2(size.x - island3.scaledSize.x, 1230);
    await add(island2);
    island2.position = Vector2(size.x - island2.scaledSize.x, size.y - island2.scaledSize.y - 100);
    await add(island1);
    island1.position = Vector2(0, size.y - island1.scaledSize.y);

    final palmSprite = await Sprite.load('png/map/palm.png');
    palm.size = palmSprite.srcSize;
    palm.sprite = palmSprite;
    palm.position = Vector2(size.x - palm.scaledSize.x, size.y - palm.scaledSize.y / 1.5);
    await add(palm);

    await island1.add(levels.first);
    levels.first.position = Vector2(400, 1250);
    await island1.add(levels.elementAt(1));
    levels.elementAt(1).position = Vector2(900, 1450);
    await island2.add(levels.elementAt(2));
    levels.elementAt(2).position = Vector2(650, 150);
    await island3.add(levels.elementAt(3));
    levels.elementAt(3).position = Vector2(200, -250);
    await island4.add(levels.elementAt(4));
    levels.elementAt(4).position = Vector2(50, -350);
    await island5.add(levels.elementAt(5));
    levels.elementAt(5).position = Vector2(50, -350);
    await island6.add(levels.elementAt(6));
    levels.elementAt(6).position = Vector2(1500, 1000);
    await island6.add(levels.elementAt(7));
    levels.elementAt(7).position = Vector2(800, 850);
    await island7.add(levels.elementAt(8));
    levels.elementAt(8).position = Vector2(300, 300);
    await island8.add(levels.last);
    levels.last.position = Vector2(400, -180);

    scale = Vector2(gameRef.size.x / maxWidth, gameRef.size.y / maxHeight);
  }

  void init(int start) {
    var num = start;
    for (var level in levels) {
      level.init(num);
      level.onTap = onTapLevel;
      num++;
    }

    levels.first.setDone(2);
    levels.elementAt(1).setActive();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    scale = Vector2(size.x / maxWidth, size.y / maxHeight);
    palm.scale = Vector2(0.5, 0.75);
  }
}
