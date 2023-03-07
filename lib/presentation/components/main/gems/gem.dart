import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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
      textRenderer: TextPaint(style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)));

  Gem({required this.type}) {
    size = gemSize;
    scale = Vector2.all(0.9);
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

class GemEmpty extends Gem {
  GemEmpty() : super(type: GemType.empty) {
    // debugMode = true;
  }
}

mixin GemMovable on Gem {
  Future<void> move(Vector2 pos, [double speed = 1000, bool debug = false]) async {
    final completer = Completer<void>();
    final start = DateTime.now();
    if (debug) print('$_pos - $pos');
    await add(MoveToEffect(
      pos,
      EffectController(
        speed: speed,
        // onMax: () {
        //   // position = pos;
        //   if (!completer.isCompleted) completer.complete();
        // },
      ),
      onComplete: () {
        // position = pos;
        if (!completer.isCompleted) completer.complete();
      },
    ));
    await completer.future;
    final diff = DateTime.now().difference(start).inMicroseconds;
    if (debug) print('$_pos - $pos, $diff');
  }
}

mixin GemClerable on Gem {
  Future<void> clear(Vector2 pos, {double speed = 1000, double duration = 2}) async {
    final completer = Completer<void>();
    await add(
      ScaleEffect.to(Vector2.all(0.1), EffectController(duration: duration)),
    );
    await add(MoveEffect.to(
      pos,
      EffectController(speed: speed),
      onComplete: () {
        // position = pos;
        if (!completer.isCompleted) completer.complete();
      },
    ));
    await completer.future;
  }
}

class GemColored extends Gem with GemMovable, GemClerable {
  final GemColor color;

  GemColored({required this.color}) : super(type: GemType.colored);

  @override
  Future<void> onLoad() async {
    final sprite = await Sprite.load('png/gems/$color.png');
    final fg = SpriteComponent(sprite: sprite);

    await add(fg);

    await super.onLoad();
  }
}
