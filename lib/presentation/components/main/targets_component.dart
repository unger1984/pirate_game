import 'package:flame/components.dart';
import 'package:pirate/domain/entities/target_entity.dart';
import 'package:pirate/presentation/components/main/targets/chest_component.dart';
import 'package:pirate/presentation/components/main/targets/counter_component.dart';
import 'package:pirate/presentation/components/main/targets/stats_component.dart';
import 'package:pirate/presentation/pirate_game.dart';
import 'package:pirate/presentation/screens/main_screen.dart';
import 'package:pirate/utils/const.dart';
import 'package:pirate/utils/helper.dart';

class TargetsComponent extends PositionComponent with HasGameRef<PirateGame> {
  final SpriteComponent sand = SpriteComponent();
  final SpriteComponent palms = SpriteComponent();
  final SpriteComponent palmLeft = SpriteComponent();
  final SpriteComponent palmRight = SpriteComponent();
  final StatsComponent stats = StatsComponent();
  final ChestComponent chest1 = ChestComponent(type: ChestType.left);
  final ChestComponent chest2 = ChestComponent(type: ChestType.center);
  final ChestComponent chest3 = ChestComponent(type: ChestType.right);
  final CounterComponent counter = CounterComponent();
  final MainScreen screen;

  int limit = 0;
  TargetType type = TargetType.moves;
  double timer = 0;

  TargetsComponent({required this.screen});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final palmsSprite = await Sprite.load('png/palms_back.png');
    palms.sprite = palmsSprite;
    palms.size = palmsSprite.srcSize;
    final sandSprite = await Sprite.load('png/sand_main.png');
    sand.sprite = sandSprite;
    sand.size = sandSprite.srcSize;
    final palmLeftSprite = await Sprite.load('png/palm_left.png');
    palmLeft.sprite = palmLeftSprite;
    palmLeft.size = palmLeftSprite.srcSize;
    final palmRightSprite = await Sprite.load('png/palm_right.png');
    palmRight.sprite = palmRightSprite;
    palmRight.size = palmRightSprite.srcSize;

    final sandSize = sand.size;
    final statsSize = stats.size;

    size = Vector2(sandSize.x, palmLeft.size.y + sandSize.y + statsSize.y - 100);

    palms.position = Vector2(size.x / 2 - palms.size.x / 2, palmLeft.scaledSize.y - palms.scaledSize.y - 80);
    stats.position = Vector2(0, size.y - statsSize.y - 100);
    sand.position = Vector2(0, size.y - sandSize.y - 70);
    palmRight.position = Vector2(sandSize.x - palmRight.size.x / 2, 70);
    await add(palms);
    await add(palmLeft);
    await add(palmRight);
    await add(sand);
    await add(stats);

    await add(chest1);
    await add(chest2);
    await add(chest3);

    await add(counter);
    counter.position = Vector2(size.x / 2, 0);

    chest1.position = Vector2(0, 100);
    chest2.position = Vector2(size.x / 2 - chest2.size.x / 2, 100);
    chest3.position = Vector2(size.x - chest3.size.x, 100);

    position = Vector2.zero();
    position = Vector2(0, gameRef.size.y / 3 - scaledSize.y + 50);

    // stats.setProgress(50);

    onGameResize(gameRef.size);
  }

  @override
  void onGameResize(Vector2 size) {
    scale = Vector2.all(size.x / maxWidth);
    position = Vector2(0, size.y / 3 - scaledSize.y + 50);
    super.onGameResize(size);
  }

  void init(TargetEntity target) {
    timer = 0;
    stats.init(target.star1, target.star2, target.star3);
    chest1.init(target.ches1);
    chest2.init(target.ches2);
    chest3.init(target.ches3);
    type = target.type;
    limit = target.limit;
    switch (type) {
      case TargetType.timer:
        counter.text = formatTime(limit);
        break;
      case TargetType.moves:
        counter.text = (limit - timer).toInt().toString();
        break;
    }
  }

  void addScore(int score) {
    stats.addScore(score);
  }

  bool get complete =>
      chest1.status == ChestStatus.close && chest2.status == ChestStatus.close && chest3.status == ChestStatus.close;

  @override
  void update(double dt) {
    super.update(dt);
    if (type == TargetType.timer) {
      timer += dt;
      if (limit - timer >= 0) {
        counter.text = formatTime((limit - timer).toInt());
      }
      if (limit - timer <= 0) {
        screen.endLimit();
      }
    }
  }

  void move() {
    timer++;
    if (limit - timer >= 0) {
      counter.text = (limit - timer).toInt().toString();
    }
    if (limit - timer <= 0) {
      screen.endLimit();
    }
  }
}
