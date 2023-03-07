import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum GemType {
  empty('empty'),
  colored('colored');

  final String _type;

  const GemType(this._type);

  @override
  String toString() => _type;
}

enum GemColor {
  blue('blue'),
  green('green'),
  // orange('orange'),
  red('red'),
  yellow('yellow'),
  purpure('purpure');

  final String _color;

  const GemColor(this._color);

  @override
  String toString() => _color;
}

abstract class Gem extends PositionComponent {
  static final Vector2 gemSize = Vector2.all(114);
  final GemType type;
  Vector2 _pos = Vector2.zero();
  final txt = TextComponent(
    text: '0.0x0.0',
    textRenderer: TextPaint(style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
  );

  Gem({required this.type}) {
    size = gemSize;
    scale = Vector2.all(0.9);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    // await add(txt);
    // txt.position = size / 2 - txt.size / 2;
    await super.onLoad();
  }

  set pos(Vector2 val) {
    _pos = val;
    txt.text = '${_pos.x}x${_pos.y}';
  }

  Vector2 get pos => _pos;
}
