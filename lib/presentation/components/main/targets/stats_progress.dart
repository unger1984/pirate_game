import 'package:flame/components.dart';

class StatsProgress extends PositionComponent {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final bgSprite = await Sprite.load('png/progress_inactive.png');
    size = bgSprite.srcSize;
    final bg = SpriteComponent(sprite: bgSprite);
    bg.size = bgSprite.srcSize;

    await add(bg);
  }
}
