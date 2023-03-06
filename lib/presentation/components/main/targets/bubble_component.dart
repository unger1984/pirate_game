import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

class BubbleComponent extends SpriteComponent {
  late final Sprite spriteBubbleGreen;
  late final Sprite spriteBubbleOrange;
  late final TextComponent _text;
  final _gem = SpriteComponent(size: Vector2.all(64));
  late String _gemSpriteAsset;
  int _targetCount = 0;
  int _current = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final colorWhite = BasicPalette.white.color;

    spriteBubbleGreen = await Sprite.load('png/bubble_green.png');
    spriteBubbleOrange = await Sprite.load('png/bubble_orange.png');

    size = spriteBubbleGreen.srcSize;
    sprite = spriteBubbleOrange;

    await add(_gem);
    _gem.position = Vector2(size.x - _gem.size.x - 10, size.y / 2 - _gem.size.y / 2 - 20);
    _gemSpriteAsset = 'blue';
    _gem.sprite = await Sprite.load('png/gems/$_gemSpriteAsset.png');

    _text = TextComponent(
      text: '$_current/$_targetCount'.padLeft(7, ' '),
      textRenderer: TextPaint(
        style: TextStyle(
          color: colorWhite,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    _text.position = Vector2(10, size.y / 2 - _text.size.y / 2 - 20);
    await add(_text);
  }

  int get current => _current;
  set current(int val) {
    if (val > _targetCount) val = _targetCount;
    if (val == _targetCount) {
      sprite = spriteBubbleGreen;
    }
    _current = val;
    _text.text = '$_current/$_targetCount'.padLeft(7, ' ');
  }

  Future<void> setGem(String value) async {
    _gemSpriteAsset = value;
    _gem.sprite = await Sprite.load('png/gems/$_gemSpriteAsset.png');
  }

  String get gem => _gemSpriteAsset;

  set target(int value) {
    _targetCount = value;
    _current = 0;
    _text.text = '$_current/$_targetCount'.padLeft(7, ' ');
  }

  void addScore(int value) {
    current += value;
  }
}
