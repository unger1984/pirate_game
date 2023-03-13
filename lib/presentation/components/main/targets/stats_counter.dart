import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

class StatsCounter extends PositionComponent {
  late final TextComponent _startText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final colorWhite = BasicPalette.white.color;

    final bgSprite = await Sprite.load('png/targets/coin_place.png');
    final coinSprite = await Sprite.load('png/targets/coin_icon.png');
    size = Vector2(bgSprite.srcSize.x + coinSprite.srcSize.x / 2 - 10, coinSprite.srcSize.y - 15);
    final bg = SpriteComponent(sprite: bgSprite);
    await add(bg);
    final coin = SpriteComponent(sprite: coinSprite);
    coin.position = Vector2(bg.size.x - coin.size.x / 2 - 10, -10);
    await add(coin);

    _startText = TextComponent(
      text: '0'.padLeft(6, ' '),
      textRenderer: TextPaint(
        style: TextStyle(
          color: colorWhite,
          fontFamily: 'Krabuler',
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    _startText.position = Vector2(0, size.y / 2 - _startText.size.y / 2);
    await add(_startText);
  }

  set count(int value) {
    _startText.text = value.toString().padLeft(6, ' ');
  }

  int get count => int.parse(_startText.text);
}
