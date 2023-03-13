import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

class CounterComponent extends SpriteComponent {
  late final Sprite bgSprite;
  late final TextComponent _text;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final colorWhite = BasicPalette.white.color;

    bgSprite = await Sprite.load('png/targets/counter.png');
    size = bgSprite.srcSize;
    sprite = bgSprite;
    anchor = Anchor.center;

    _text = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: TextStyle(
          color: colorWhite,
          fontFamily: 'Krabuler',
          fontSize: 82.2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    _text.anchor = Anchor.center;
    _text.position = Vector2(size.x / 2 + 15, size.y / 2);
    await add(_text);
  }

  set text(String value) {
    _text.text = value;
  }
}
