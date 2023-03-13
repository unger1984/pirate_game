import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:pirate/presentation/components/common/star_component.dart';
import 'package:pirate/presentation/components/popup/popup_component.dart';

class PopupCompletedComponent extends PopupComponent {
  final _star1 = StarComponent();
  final _star2 = StarComponent();
  final _star3 = StarComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load('png/ui/popup_completed.png');
    final sp = sprite;
    if (sp != null) {
      size = sp.srcSize;
    }

    final colorWhite = BasicPalette.white.color;

    await add(_star1);
    _star1.size *= 2.5;
    _star1.position = Vector2(200, -100);
    await add(_star2);
    _star2.size *= 3;
    _star2.position = Vector2(size.x / 2 - _star2.size.x / 2, -150);
    await add(_star3);
    _star3.size *= 2.5;
    _star3.position = Vector2(size.x - _star3.size.x - 200, -100);
  }
}
