import 'package:flame/components.dart';
import 'package:pirate/domain/entities/target_chest_entity.dart';
import 'package:pirate/domain/entities/target_entity.dart';
import 'package:pirate/presentation/components/common/button_component.dart';
import 'package:pirate/presentation/components/main/targets_component.dart';
import 'package:pirate/presentation/components/popup/popup_settings_component.dart';
import 'package:pirate/presentation/pirate_game.dart';
import 'package:pirate/utils/const.dart';

class MainScreen extends PositionComponent with HasGameRef<PirateGame> {
  final popupSettings = PopupSettingsComponent();
  final bg = SpriteComponent();
  final btnSettings = ButtonComponent(withScale: true);
  final tagets = TargetsComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = gameRef.size;

    bg.sprite = await Sprite.load('jpg/bg_level.jpg');
    bg.size = size;
    await add(bg);

    btnSettings.sprite = await Sprite.load('png/btn_settings.png');
    btnSettings.onTap = showSettings;

    await add(tagets);

    tagets.init(
      const TargetEntity(
        ches1: TargetChestEntity(gem: 'red', total: 5),
        ches2: TargetChestEntity(gem: 'green', total: 5),
        ches3: TargetChestEntity(gem: 'blue', total: 5),
        star1: 100,
        star2: 150,
        star3: 200,
      ),
    );

    await add(btnSettings);
    await add(popupSettings);

    onGameResize(size);
  }

  @override
  void onGameResize(Vector2 size) {
    bg.size = size;
    var mX = size.x * 50 / maxWidth;
    var mY = size.y * 50 / maxHeight;
    btnSettings.position = Vector2(size.x - btnSettings.scaledSize.x - mX, mY);
    super.onGameResize(size);
  }

  void showSettings() {
    popupSettings.show();
  }
}
