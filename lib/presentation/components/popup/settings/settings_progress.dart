import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pirate/domain/datasources/audio_source.dart';
import 'package:pirate/domain/usecases/sound_use_case.dart';
import 'package:pirate/presentation/blocs/sound_bloc.dart';
import 'package:pirate/presentation/components/common/button_component.dart';
import 'package:pirate/presentation/components/popup/settings/progress_component.dart';

enum SettingsProgressType {
  music,
  sound,
}

class SettingsSprites {
  final String ico;
  final String progress;
  final String btnPlus;
  final String btnMinus;

  const SettingsSprites({
    required this.ico,
    required this.progress,
    required this.btnPlus,
    required this.btnMinus,
  });
}

SettingsSprites spritesByType(SettingsProgressType type) {
  switch (type) {
    case SettingsProgressType.sound:
      return const SettingsSprites(
        ico: 'png/ui/sound.png',
        progress: 'png/ui/progress_active_green.png',
        btnMinus: 'png/ui/btn_minus_button.png',
        btnPlus: 'png/ui/btn_plus_button.png',
      );
    case SettingsProgressType.music:
      return const SettingsSprites(
        ico: 'png/ui/music.png',
        progress: 'png/ui/progress_active_orange.png',
        btnMinus: 'png/ui/btn_minus_orange.png',
        btnPlus: 'png/ui/btn_plus_orange.png',
      );
  }
}

class SettingsProgress extends PositionComponent {
  final _audioCase = SoundUseCase(audioSource: GetIt.I<AudioSource>());
  final SettingsProgressType type;
  late final ProgressComponent progress;
  late final SoundBLoC _soundBLoC;
  StreamSubscription<SoundState>? _subscription;

  SettingsProgress({required this.type}) {
    size = Vector2(700, 250);
  }

  @override
  @mustCallSuper
  void onRemove() {
    super.onRemove();
    _subscription?.cancel();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprites = spritesByType(type);

    _soundBLoC = ancestors().whereType<FlameBlocProvider<SoundBLoC, SoundState>>().first.bloc;

    _subscription = _soundBLoC.stream.listen(onNewState);

    final icoComponetn = SpriteComponent(sprite: await Sprite.load(sprites.ico));
    icoComponetn.position = Vector2(size.x / 2 - icoComponetn.size.x / 2, 0);
    add(icoComponetn);

    progress = ProgressComponent(
      sprite: await Sprite.load('png/ui/progress_settings_inactive.png'),
      child: SpriteComponent(sprite: await Sprite.load(sprites.progress)),
    );
    progress.position = Vector2(size.x / 2 - progress.size.x / 2, icoComponetn.size.y + 50);
    add(progress);

    final pPos = progress.position;

    final btnMinus = ButtonComponent(
      sprite: await Sprite.load(sprites.btnMinus),
      onTap: minusSound,
    )..size = Vector2(137, 132);
    btnMinus.position = Vector2(0, pPos.y - 20);
    add(btnMinus);

    final btnPlus = ButtonComponent(
      sprite: await Sprite.load(sprites.btnPlus),
      onTap: addSound,
    )..size = Vector2(137, 132);
    btnPlus.position = Vector2(size.x - btnPlus.size.x, pPos.y - 20);
    add(btnPlus);

    switch (type) {
      case SettingsProgressType.music:
        progress.setProgress(_audioCase.getMusicLevel() * 100);
        break;
      case SettingsProgressType.sound:
        progress.setProgress(_audioCase.getSoundLevelt() * 100);
        break;
    }
  }

  void addSound() {
    switch (type) {
      case SettingsProgressType.music:
        _soundBLoC.add(const ChangeMusicSoundEvent(0.1));
        break;
      case SettingsProgressType.sound:
        _soundBLoC.add(const ChangeSoundSoundEvent(0.1));
        break;
    }
  }

  void minusSound() {
    switch (type) {
      case SettingsProgressType.music:
        _soundBLoC.add(const ChangeMusicSoundEvent(-0.1));
        break;
      case SettingsProgressType.sound:
        _soundBLoC.add(const ChangeSoundSoundEvent(-0.1));
        break;
    }
  }

  void onNewState(SoundState state) {
    state.when(
      success: (levelMusic, levelSound) {
        switch (type) {
          case SettingsProgressType.music:
            progress.setProgress(levelMusic * 100);
            break;
          case SettingsProgressType.sound:
            progress.setProgress(levelSound * 100);
            break;
        }
      },
    );
  }
}
