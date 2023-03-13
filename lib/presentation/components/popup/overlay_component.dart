import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:pirate/presentation/components/popup/popup_component.dart';
import 'package:pirate/presentation/pirate_game.dart';

class OverlayComponent extends SpriteComponent with HasGameRef<PirateGame>, TapCallbacks {
  late final PopupComponent popup;
  bool hideOnTap = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('png/ui/overlay.png');
    size = gameRef.size;
    position = Vector2.zero();
  }

  @override
  void onGameResize(Vector2 size) {
    this.size = size;
    position = Vector2.zero();
    super.onGameResize(size);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (hideOnTap) popup.hide();
  }
}
