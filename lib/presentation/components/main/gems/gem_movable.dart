import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:pirate/presentation/components/main/gems/gem.dart';

mixin GemMovable on Gem {
  final _shakeEffect = SequenceEffect(
    [
      RotateEffect.to(pi / 28, EffectController(duration: 0.1)),
      RotateEffect.to(-pi / 28, EffectController(duration: 0.1)),
    ],
    infinite: true,
  );

  Future<void> move(Vector2 target, {double speed = 1000}) async {
    final completer = Completer<void>();
    await add(
      MoveToEffect(
        target,
        EffectController(speed: speed),
        onComplete: () {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );
    await completer.future;
  }

  void startShake() {
    add(_shakeEffect);
  }

  void cancelShake() {
    if (isMounted && children.contains(_shakeEffect)) {
      remove(_shakeEffect);
      add(RotateEffect.to(0, EffectController(duration: 0.1)));
    }
  }
}
