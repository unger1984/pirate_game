import 'package:flame/components.dart';
import 'package:pirate/presentation/pirate_game.dart';

class IslandComponent extends SpriteComponent with HasGameRef<PirateGame> {
  final int _num;

  IslandComponent(this._num);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('png/map/island_$_num.png');
    final sp = sprite;
    if (sp != null) {
      size = sp.srcSize;
    }

    onGameResize(gameRef.size);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    scale = Vector2(0.35, 0.45);
    // scale = Vector2(1, size.x / maxWidth);
    // scale = Vector2(size.x / maxWidth, size.y / maxHeight);
  }
}
