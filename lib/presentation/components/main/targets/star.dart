import 'package:flame/components.dart';

class Star extends SpriteComponent {
  late final Sprite spriteActive;
  late final Sprite spriteInactive;
  bool _active = false;

  @override
  Future<void> onLoad() async {
    spriteActive = await Sprite.load('png/targets/star_full.png');
    spriteInactive = await Sprite.load('png/targets/star_empty.png');
    sprite = spriteInactive;
    size = spriteInactive.srcSize;

    await super.onLoad();
  }

  bool get active => _active;

  set active(bool val) {
    _active = val;
    sprite = val ? spriteActive : spriteInactive;
  }
}
