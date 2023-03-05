import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart' hide AudioSource;
import 'package:pirate/domain/datasources/audio_source.dart';
import 'package:pirate/domain/repositories/settings_repository.dart';

class AudioSourceImpl extends AudioSource {
  final SettingsRepository _settingsRepository;
  final _bg = AudioPlayer();
  final _sound = AudioPlayer();
  double _bgLevel;
  double _soundLevel;

  AudioSourceImpl({required SettingsRepository settingsRepository})
      : _settingsRepository = settingsRepository,
        _bgLevel = settingsRepository.levelMusic,
        _soundLevel = settingsRepository.levelSound {
    WidgetsBinding.instance.addObserver(this);
    _bg.setLoopMode(LoopMode.all);
    _sound.setLoopMode(LoopMode.off);
  }

  @override
  Future<void> playBg(String asset) async {
    await _bg.setAsset(asset);
    await _bg.setVolume(_bgLevel);
    await _bg.play();
  }

  @override
  Future<void> playSound(String asset) async {
    await _sound.setAsset(asset);
    await _sound.setVolume(_soundLevel);
    _sound.play();
  }

  @override
  double get bgLevel => _bgLevel;

  @override
  set bgLevel(double value) {
    _bgLevel = value;
    _settingsRepository.levelMusic = value;
    _bg.setVolume(value);
  }

  @override
  double get soundLevel => _soundLevel;

  @override
  set soundLevel(double value) {
    _soundLevel = value;
    _settingsRepository.levelSound = value;
    _sound.setVolume(value);
  }

  @override
  Future<void> dispose() async {
    await _bg.stop();
    await _sound.stop();
    await _bg.dispose();
    await _sound.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bg.play();
    } else {
      _bg.pause();
    }
  }
}
