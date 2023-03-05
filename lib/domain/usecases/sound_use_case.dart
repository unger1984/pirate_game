import 'package:pirate/domain/datasources/audio_source.dart';

class SoundUseCase {
  final AudioSource _audio;

  SoundUseCase({required AudioSource audioSource}) : _audio = audioSource;

  double getMusicLevel() {
    var level = _audio.bgLevel;
    if (level > 1) {
      level = 1;
    } else {
      if (level < 0) {
        level = 0;
      }
    }

    return level;
  }

  double getSoundLevelt() {
    var level = _audio.soundLevel;

    if (level > 1) {
      level = 1;
    } else {
      if (level < 0) {
        level = 0;
      }
    }

    return level;
  }

  void setMusicLevel(double value) {
    if (value > 1) {
      value = 1;
    } else if (value < 0) {
      value = 0;
    }
    _audio.bgLevel = value;
  }

  void setSoundLevel(double value) {
    if (value > 1) {
      value = 1;
    } else if (value < 0) {
      value = 0;
    }
    _audio.soundLevel = value;
  }

  Future<void> dispose() async {
    await _audio.dispose();
  }

  Future<void> playMusic(String asset) async {
    await _audio.playBg(asset);
  }

  Future<void> playSound(String asset) async {
    await _audio.playSound(asset);
  }
}
