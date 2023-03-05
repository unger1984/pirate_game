import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pirate/domain/datasources/audio_source.dart';
import 'package:pirate/domain/usecases/sound_use_case.dart';
import 'package:pirate/utils/const.dart';

class ButtonComponent extends SpriteComponent with HasGameRef, Tappable {
  final soundCase = SoundUseCase(audioSource: GetIt.I<AudioSource>());
  final bool withScale;
  final bool propagate;
  void Function()? onTap;

  ButtonComponent({Sprite? sprite, this.onTap, this.withScale = false, this.propagate = false}) {
    super.sprite = sprite;
    if (sprite != null) {
      size = sprite.srcSize;
    }
  }

  @override
  set sprite(Sprite? value) {
    super.sprite = value;
    if (value != null) {
      size = value.srcSize;
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    onGameResize(gameRef.size);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final sp = sprite;
    if (sp != null && withScale) {
      scale = Vector2.all(size.x / maxWidth);
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    add(ColorEffect(
      Colors.black.withOpacity(0.1),
      const Offset(0.0, 0.1),
      EffectController(duration: 0.1),
    ));

    return propagate ? super.onTapDown(info) : false;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    add(ColorEffect(
      Colors.black.withOpacity(0.1),
      Offset.zero,
      EffectController(duration: 0.1),
    ));
    soundCase.playSound('assets/audio/click.mp3');
    final tap = onTap;
    if (tap != null) {
      tap();
    }

    return propagate ? super.onTapUp(info) : false;
  }

  @override
  bool onTapCancel() {
    add(ColorEffect(
      Colors.black.withOpacity(0.1),
      Offset.zero,
      EffectController(duration: 0.1),
    ));

    return propagate ? super.onTapCancel() : false;
  }
}
