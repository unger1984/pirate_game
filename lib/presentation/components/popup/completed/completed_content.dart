import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:pirate/generated/l10n.dart';
import 'package:pirate/presentation/components/common/button_component.dart';
import 'package:pirate/presentation/pirate_game.dart';

class CompletedContent extends SpriteComponent with HasGameRef<PirateGame> {
  late final TextComponent _title;
  late final TextComponent _score;
  final btnRestart = ButtonComponent();
  final btnMap = ButtonComponent();
  final btnNext = ButtonComponent();

  @override
  Future<void> onLoad() async {
    final colorWhite = BasicPalette.white.color;
    await super.onLoad();

    final bgSprite = await Sprite.load('png/ui/bg_info.png');
    sprite = await Sprite.load('png/ui/paper_completed.png');
    final sp = sprite;
    if (sp != null) {
      size = sp.srcSize;
    }

    final bg = SpriteComponent(sprite: bgSprite);
    final bgSize = bgSprite.srcSize;
    bg.size = bgSize;
    bg.position = Vector2(size.x / 2 - bgSize.x / 2, size.y / 2 - bgSize.y / 2) + Vector2(0, -20);
    await add(bg);

    final btnRestartSprite = await Sprite.load('png/ui/btn_repeat.png');
    btnRestart.sprite = btnRestartSprite;
    btnRestart.size = btnRestartSprite.srcSize;
    await add(btnRestart);
    btnRestart.position = Vector2(bg.position.x + 20, bgSize.y + btnRestart.size.y / 4);
    btnRestart.onTap = _restart;

    final btnMapSprite = await Sprite.load('png/ui/btn_menu.png');
    btnMap.sprite = btnMapSprite;
    btnMap.size = btnMapSprite.srcSize;
    await add(btnMap);
    btnMap.position = Vector2(bgSize.x - bg.position.x + 20, bgSize.y + btnMap.size.y / 4);

    final btnNextSprite = await Sprite.load('png/ui/btn_next.png');
    btnNext.sprite = btnNextSprite;
    btnNext.size = btnNextSprite.srcSize;
    await add(btnNext);
    btnNext.position = Vector2(bgSize.x / 2 + 20, bgSize.y + btnNext.size.y / 4);
    remove(btnNext);

    _title = TextComponent(
      text: S.current.level_result(10, S.current.failed),
      textRenderer: TextPaint(
        style: TextStyle(
          color: colorWhite,
          fontFamily: 'Krabuler',
          fontSize: 64,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    await add(_title);
    _title.position = Vector2(size.x / 2 - _title.size.x / 2, 150);

    _score = TextComponent(
      text: S.current.score(10),
      textRenderer: TextPaint(
        style: TextStyle(
          color: colorWhite,
          fontFamily: 'Krabuler',
          fontSize: 54,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    await add(_score);
    _score.position = Vector2(size.x / 2 - _score.size.x / 2, 250);
  }

  void _clear() {
    if (children.contains(btnNext)) remove(btnNext);
    btnNext.removeFromParent();
  }

  Future<void> setResult(bool win, int level, int score) async {
    _clear();
    if (win) await add(btnNext);
    _title.text = S.current.level_result(level, win ? S.current.completed : S.current.failed);
    _title.position = Vector2(size.x / 2 - _title.size.x / 2, 150);
    _score.text = S.current.score(score);
    _score.position = Vector2(size.x / 2 - _score.size.x / 2, 250);
  }

  void _restart() {
    gameRef.mainScreen.restart();
  }
}
