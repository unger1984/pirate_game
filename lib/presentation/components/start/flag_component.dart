import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';

class FlagComponent extends SpriteComponent with HasGameRef {
  final TextComponent title1 = TextComponent(
    text: 'THE',
    textRenderer: TextPaint(
      style: TextStyle(
        color: BasicPalette.white.color,
        fontSize: 44,
      ),
    ),
  );
  final TextComponent title2 = TextComponent(
    text: 'PIRATE',
    textRenderer: TextPaint(
      style: TextStyle(
        color: BasicPalette.white.color,
        fontSize: 84,
      ),
    ),
  );
  final TextComponent title3 = TextComponent(
    text: 'GAME',
    textRenderer: TextPaint(
      style: TextStyle(
        color: BasicPalette.white.color,
        fontSize: 44,
      ),
    ),
  );
  final PositionComponent text = PositionComponent();

  @override
  Future<void> onLoad() async {
    position = Vector2.zero();
    sprite = await Sprite.load('png/flag.png');
    final sp = sprite;
    if (sp != null) {
      size = sp.srcSize;
    }
    final size1 = title1.size;
    final size2 = title2.size;
    final size3 = title3.size;

    text.size = Vector2(title2.size.x, size1.y + size2.y + title3.size.y + 40);
    await text.add(title1);
    await text.add(title2);
    await text.add(title3);

    final testSize = text.size;

    title1.position += Vector2(testSize.x / 2 - title1.size.x / 2, 0);
    title2.position += Vector2(testSize.x / 2 - size2.x / 2, size1.y + 20);
    title3.position += Vector2(testSize.x / 2 - size3.x / 2, size1.y + size2.y + 40);

    await add(text);

    text.position = Vector2(width / 2 - text.scaledSize.x / 2, height / 2 - text.scaledSize.y / 2);

    onGameResize(gameRef.size);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final sp = sprite;
    if (sp != null) {
      final spSize = sp.srcSize;

      final width = size.x;
      final height = width * spSize.y / spSize.x;
      this.size = Vector2(width, height);
      text.scale = Vector2.all(width / spSize.x);

      text.position = Vector2(width / 2 - text.scaledSize.x / 2, height / 2 - text.scaledSize.y / 2);
    }
  }
}
