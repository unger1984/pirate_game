import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:pirate/generated/l10n.dart';
import 'package:pirate/presentation/components/common/button_component.dart';
import 'package:pirate/presentation/components/popup/popup_settings_component.dart';
import 'package:pirate/presentation/components/start/flag_component.dart';
import 'package:pirate/presentation/pirate_game.dart';
import 'package:pirate/utils/const.dart';

class StartScreen extends PositionComponent with HasGameRef<PirateGame> {
  // final overlay = OverlayComponent();
  final popupSettings = PopupSettingsComponent();
  final bg = SpriteComponent();
  final flag = FlagComponent();
  final btnSettings = ButtonComponent(withScale: true);
  final btnStart = ButtonComponent(withScale: true);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = gameRef.size;

    final colorWhite = BasicPalette.white.color;

    bg.sprite = await Sprite.load('jpg/bg_empty.jpg');
    bg.size = size;

    await add(bg);
    await add(flag);

    btnSettings.sprite = await Sprite.load('png/ui/btn_settings.png');
    btnSettings.onTap = showSettings;
    await add(btnSettings);

    btnStart.sprite = await Sprite.load('png/ui/btn_start.png');
    btnStart.onTap = start;
    final startText = TextComponent(
      text: S.current.start,
      textRenderer: TextPaint(
        style: TextStyle(
          color: colorWhite,
          fontSize: 85.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    startText.position = btnStart.size / 2 - startText.size / 2;
    await btnStart.add(startText);
    await add(btnStart);
    btnStart.position = Vector2(
      size.x / 2 - (btnStart.scaledSize.x / 2),
      flag.position.y + flag.size.y,
    );

    await add(popupSettings);

    onGameResize(size);
  }

  @override
  void onGameResize(Vector2 size) {
    bg.size = size;
    var mX = size.x * 50 / maxWidth;
    var mY = size.y * 50 / maxHeight;
    btnSettings.position = Vector2(size.x - btnSettings.scaledSize.x - mX, mY);

    btnStart.position = Vector2(
      size.x / 2 - (btnStart.scaledSize.x / 2),
      flag.position.y + flag.size.y,
    );
    super.onGameResize(size);
  }

  Future<void> showSettings() async {
    await popupSettings.show();
  }

  Future<void> start() async {
    await gameRef.onStart();
  }
}
