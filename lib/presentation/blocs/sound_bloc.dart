import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pirate/domain/usecases/sound_use_case.dart';

part 'sound_bloc.freezed.dart';

@freezed
class SoundEvent with _$SoundEvent {
  const SoundEvent._();
  const factory SoundEvent.init() = InitSoundEvent;
  const factory SoundEvent.changeMusic(double level) = ChangeMusicSoundEvent;
  const factory SoundEvent.changeSound(double level) = ChangeSoundSoundEvent;
}

@freezed
class SoundState with _$SoundState {
  const SoundState._();
  const factory SoundState.success(double levelMusic, double levelSound) = SuccessSoundState;
}

class SoundBLoC extends Bloc<SoundEvent, SoundState> {
  final SoundUseCase _soundUseCase;

  SoundBLoC({required SoundUseCase soundUseCase})
      : _soundUseCase = soundUseCase,
        super(const SuccessSoundState(1, 1)) {
    on<SoundEvent>(
      (event, emitter) => event.map(
        init: (event) => _init(event, emitter),
        changeMusic: (event) => _changeMusic(event, emitter),
        changeSound: (event) => _changeSound(event, emitter),
      ),
    );

    add(const InitSoundEvent());
    _soundUseCase.playMusic('assets/audio/bg.mp3');
  }

  @override
  Future<void> close() async {
    await _soundUseCase.dispose();
    await super.close();
  }

  void _init(_, Emitter<SoundState> emitter) {
    final levelMusic = _soundUseCase.getMusicLevel();
    final levelSound = _soundUseCase.getSoundLevelt();
    emitter(SuccessSoundState(levelMusic, levelSound));
  }

  void _changeMusic(ChangeMusicSoundEvent event, Emitter<SoundState> emitter) {
    var levelMusic = _soundUseCase.getMusicLevel();
    final levelSound = _soundUseCase.getSoundLevelt();
    levelMusic += event.level;
    _soundUseCase.setMusicLevel(levelMusic);
    emitter(SuccessSoundState(levelMusic, levelSound));
  }

  void _changeSound(ChangeSoundSoundEvent event, Emitter<SoundState> emitter) {
    final levelMusic = _soundUseCase.getMusicLevel();
    var levelSound = _soundUseCase.getSoundLevelt();
    levelSound += event.level;
    _soundUseCase.setSoundLevel(levelSound);
    emitter(SuccessSoundState(levelMusic, levelSound));
  }
}
