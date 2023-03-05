import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class PopupComponent extends SpriteComponent with HasGameRef {
  late Vector2 _startPos;
  bool _isOpen = false;

  @override
  Future<void> onLoad() async {
    final gameSize = gameRef.size;
    _startPos = Vector2(0, -gameSize.y - scaledSize.y);
    position = _startPos.clone();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _startPos = Vector2(0, -size.y - scaledSize.y);
    position = !_isOpen ? _startPos.clone() : size / 2 - scaledSize / 2;
  }

  void _move(Vector2 target) {
    add(MoveToEffect(target, EffectController(duration: 0.5)));
  }

  void show() {
    if (!_isOpen) {
      _move(gameRef.size / 2 - scaledSize / 2);
      _isOpen = true;
    }
  }

  void hide() {
    if (_isOpen) {
      _move(_startPos);
      _isOpen = false;
    }
  }
}
