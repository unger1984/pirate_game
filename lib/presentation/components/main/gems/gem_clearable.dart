import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:pirate/presentation/components/main/gems/gem.dart';

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
