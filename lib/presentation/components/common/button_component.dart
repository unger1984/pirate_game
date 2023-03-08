import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pirate/domain/datasources/audio_source.dart';
import 'package:pirate/domain/usecases/sound_use_case.dart';
import 'package:pirate/utils/const.dart';

class ButtonComponent extends SpriteComponent with HasGameRef, TapCallbacks {
  final soundCase = SoundUseCase(audioSource: GetIt.I<AudioSource>());
  final bool withScale;
  void Function()? onTap;

  ButtonComponent({Sprite? sprite, this.onTap, this.withScale = false}) {
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
  void onTapDown(TapDownEvent event) {
    add(ColorEffect(
      Colors.black.withOpacity(0.1),
      const Offset(0.0, 0.1),
      EffectController(duration: 0.1),
    ));
  }

  @override
  void onTapUp(TapUpEvent event) {
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
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    add(ColorEffect(
      Colors.black.withOpacity(0.1),
      Offset.zero,
      EffectController(duration: 0.1),
    ));
  }
}
