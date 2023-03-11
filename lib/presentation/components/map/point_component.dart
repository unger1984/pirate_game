import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:pirate/presentation/components/map/level_component.dart';
import 'package:pirate/presentation/pirate_game.dart';

class PointComponent extends PositionComponent with HasGameRef<PirateGame>, TapCallbacks {
  late final Sprite _spriteGreen;
  late final Sprite _spriteOrange;
  late final Sprite _spriteGrey;
  late final Sprite _spriteArrow;

  final _star1 = SpriteComponent();
  final _star2 = SpriteComponent();
  final _star3 = SpriteComponent();
  final _point = SpriteComponent();
  final _arrow = SpriteComponent();
  late final TextComponent _text;
  void Function(int)? onTap;
  LevelStatus _status = LevelStatus.close;
  int _num = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final colorWhite = BasicPalette.white.color;
    _spriteGreen = await Sprite.load('png/map/pointer_green.png');
    _spriteOrange = await Sprite.load('png/map/pointer_orange.png');
    _spriteGrey = await Sprite.load('png/map/pointer_grey.png');
    _spriteArrow = await Sprite.load('png/map/arrow.png');
    final _spriteStar = await Sprite.load('png/map/star.png');

    size = _spriteOrange.srcSize + Vector2.all(200) + Vector2(0, _spriteArrow.srcSize.y + 100);
    _point.size = _spriteOrange.srcSize + Vector2.all(200);
    _point.sprite = _spriteGrey;
    _point.position = Vector2(0, size.y - _point.size.y);
    await add(_point);

    _arrow.size = _spriteArrow.srcSize;
    _arrow.sprite = _spriteArrow;
    _arrow.position = Vector2(size.x / 2 - _arrow.size.x / 2, 0);
    await add(_arrow);
    await _arrow.add(
      MoveToEffect(Vector2(_arrow.position.x, 100), EffectController(speed: 300, alternate: true, infinite: true)),
    );

    _text = TextComponent(
      text: _num.toString(),
      textRenderer: TextPaint(
        style: TextStyle(
          color: colorWhite,
          fontSize: 102,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    await _point.add(_text);
    _text.position = Vector2(_point.size.x / 2 - _text.size.x / 2, _point.size.y / 2 - _text.size.y);

    _star1.sprite = _spriteStar;
    _star1.size = _spriteStar.srcSize;
    _star1.position = Vector2(50, size.y - _star1.size.y - 70);
    // await add(_star1);
    _star2.sprite = _spriteStar;
    _star2.size = _spriteStar.srcSize * 1.5;
    _star2.position = Vector2(size.x / 2 - _star2.size.x / 2, size.y - _star2.size.y - 20);
    // await add(_star2);
    _star3.sprite = _spriteStar;
    _star3.size = _spriteStar.srcSize;
    _star3.position = Vector2(size.x - _star3.size.x - 50, size.y - _star3.size.y - 70);
    // await add(_star3);

    remove(_arrow);
  }

  void setStatus(LevelStatus status) {
    switch (status) {
      case LevelStatus.close:
        _point.sprite = _spriteGrey;
        break;
      case LevelStatus.open:
        _point.sprite = _spriteOrange;
        add(_arrow);
        break;
      case LevelStatus.done:
        _point.sprite = _spriteGreen;
        break;
    }
    _status = status;
  }

  void setNum(int num) {
    _num = num;
    _text.text = num.toString();
    _text.position = Vector2(_point.size.x / 2 - _text.size.x / 2, _point.size.y / 2 - _text.size.y);
  }

  void _clearStars() {
    if (children.contains(_star1)) {
      remove(_star1);
    }
    if (children.contains(_star2)) {
      remove(_star2);
    }
    if (children.contains(_star3)) {
      remove(_star3);
    }
  }

  void setStar(int num) {
    _clearStars();
    if (num >= 1) {
      add(_star1);
    }
    if (num >= 2) {
      add(_star2);
    }
    if (num >= 3) {
      add(_star3);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    final tap = onTap;
    if (tap != null && (_status == LevelStatus.open || _status == LevelStatus.done)) tap(_num);
    super.onTapUp(event);
  }
}
