import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:pirate/generated/l10n.dart';
import 'package:pirate/presentation/components/common/button_component.dart';
import 'package:pirate/presentation/components/popup/popup_component.dart';
import 'package:pirate/presentation/components/popup/settings/settings_progress.dart';

class PopupSettingsComponent extends PopupComponent {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('png/ui/popup_settings.png');
    final sp = sprite;
    if (sp != null) {
      size = sp.srcSize;
    }

    final colorWhite = BasicPalette.white.color;

    final bg = SpriteComponent(sprite: await Sprite.load('png/ui/paper_big.png'));
    bg.position = size / 2 - bg.size / 2 + Vector2(20, 100);
    await add(bg);

    final titleText = TextComponent(
      text: S.current.settings,
      textRenderer: TextPaint(
        style: TextStyle(
          color: colorWhite,
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    titleText.position = Vector2(size.x / 2 - titleText.size.x / 2, 150);
    await add(titleText);

    final btnSubmit = ButtonComponent(sprite: await Sprite.load('png/ui/btn_start.png'));
    btnSubmit.position = bg.size / 2 - btnSubmit.size / 2 + Vector2(0, bg.size.y / 2 - 60);
    await bg.add(btnSubmit);

    final bgSize = bg.size;

    final btnText = TextComponent(
      text: S.current.save,
      textRenderer: TextPaint(
        style: TextStyle(
          color: colorWhite,
          fontSize: 82,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    btnText.position = btnSubmit.size / 2 - btnText.size / 2;
    await btnSubmit.add(btnText);
    btnSubmit.onTap = () {
      hide();
    };
    //
    final music = SettingsProgress(type: SettingsProgressType.music);
    music.position = Vector2(bgSize.x / 2 - music.size.x / 2, 100);
    await bg.add(music);
    //
    final sound = SettingsProgress(type: SettingsProgressType.sound);
    sound.position = Vector2(bgSize.x / 2 - sound.size.x / 2, music.position.y + music.size.y + 40);
    await bg.add(sound);

    onGameResize(gameRef.size);

    return super.onLoad();
  }
}
