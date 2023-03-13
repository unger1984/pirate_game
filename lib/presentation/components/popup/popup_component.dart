import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:pirate/presentation/components/popup/overlay_component.dart';
import 'package:pirate/presentation/pirate_game.dart';
import 'package:pirate/utils/const.dart';

class PopupComponent extends SpriteComponent with HasGameRef<PirateGame>, TapCallbacks {
  final overlay = OverlayComponent();
  late Vector2 _startPos;
  bool _isOpen = false;
  void Function()? onHide;

  @override
  Future<void> onLoad() async {
    overlay.popup = this;
    final gameSize = gameRef.size;
    _startPos = Vector2(0, -gameSize.y - scaledSize.y);
    position = _startPos.clone();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    scale = Vector2.all(size.x / maxWidth);
    _startPos = Vector2(0, -size.y - scaledSize.y);
    position = !_isOpen ? _startPos.clone() : size / 2 - scaledSize / 2;
  }

  Future<void> _move(Vector2 target) async {
    final completer = Completer<void>();
    await add(MoveToEffect(
      target,
      EffectController(speed: 2000),
      onComplete: () {
        if (!completer.isCompleted) completer.complete();
      },
    ));
    await completer.future;
  }

  Future<void> show() async {
    if (!_isOpen) {
      await _move(gameRef.size / 2 - scaledSize / 2);
      await gameRef.blocProvider.children.first.add(overlay);
      priority = 100;
      overlay.priority = 50;
      // changeParent(overlay);
      _isOpen = true;
    }
  }

  Future<void> hide() async {
    if (_isOpen) {
      await _move(_startPos);
      _isOpen = false;
      gameRef.blocProvider.children.first.remove(overlay);
      // final screen = gameRef.blocProvider.firstChild();
      // if (screen != null) {
      //   changeParent(screen);
      //   gameRef.blocProvider.firstChild()?.remove(overlay);
      // }
    }
  }
}
