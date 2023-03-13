import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:pirate/generated/l10n.dart';
import 'package:pirate/presentation/components/common/star_component.dart';
import 'package:pirate/presentation/components/popup/completed/completed_content.dart';
import 'package:pirate/presentation/components/popup/popup_component.dart';

class PopupCompletedComponent extends PopupComponent {
  late final TextComponent _title;
  final _star1 = StarComponent();
  final _star2 = StarComponent();
  final _star3 = StarComponent();
  final _content = CompletedContent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load('png/ui/popup_completed.png');
    final sp = sprite;
    if (sp != null) {
      size = sp.srcSize;
    }

    final colorWhite = BasicPalette.white.color;

    _title = TextComponent(
      text: S.current.completed,
      textRenderer: TextPaint(
        style: TextStyle(
          color: colorWhite,
          fontFamily: 'Fanta',
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    _title.position = Vector2(size.x / 2 - _title.size.x / 2, 190);
    await add(_title);

    await add(_star1);
    _star1.size *= 2.5;
    _star1.position = Vector2(200, -100);
    await add(_star2);
    _star2.size *= 3;
    _star2.position = Vector2(size.x / 2 - _star2.size.x / 2, -150);
    await add(_star3);
    _star3.size *= 2.5;
    _star3.position = Vector2(size.x - _star3.size.x - 200, -100);

    await add(_content);
    _content.position = size / 2 - _content.size / 2 + Vector2(20, 0);

    overlay.hideOnTap = false;
  }

  void _clear() {
    _star1.active = false;
    _star2.active = false;
    _star3.active = false;
  }

  void setResult(bool win, int level, int score, int stars) {
    _clear();
    _content.setResult(win, level, score);
    _title.text = win ? S.current.completed : S.current.failed;
    _title.position = Vector2(size.x / 2 - _title.size.x / 2, 190);
    if (stars >= 1) _star1.active = true;
    if (stars >= 2) _star2.active = true;
    if (stars >= 3) _star3.active = true;
  }
}
