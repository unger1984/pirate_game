import 'package:flutter/widgets.dart';

abstract class AudioSource extends WidgetsBindingObserver {
  double get bgLevel;
  set bgLevel(double val);

  double get soundLevel;
  set soundLevel(double val);

  Future<void> playBg(String asset);
  Future<void> playSound(String asset);
  Future<void> dispose();
}
