import 'package:flame/components.dart';
import 'package:pirate/domain/entities/target_chest_entity.dart';
import 'package:pirate/domain/entities/target_entity.dart';
import 'package:pirate/presentation/components/common/button_component.dart';
import 'package:pirate/presentation/components/main/board_component.dart';
import 'package:pirate/presentation/components/main/targets_component.dart';
import 'package:pirate/presentation/components/popup/popup_settings_component.dart';
import 'package:pirate/presentation/pirate_game.dart';
import 'package:pirate/utils/const.dart';

class MainScreen extends PositionComponent with HasGameRef<PirateGame> {
  final popupSettings = PopupSettingsComponent();
  final bg = SpriteComponent();
  final btnSettings = ButtonComponent(withScale: true);
  final targets = TargetsComponent();
  late final BoardComponent board = BoardComponent(screen: this);

  final targetConfig = const TargetEntity(
    ches1: TargetChestEntity(gem: 'red', total: 5),
    ches2: TargetChestEntity(gem: 'green', total: 5),
    ches3: TargetChestEntity(gem: 'blue', total: 5),
    star1: 15,
    star2: 20,
    star3: 30,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = gameRef.size;

    bg.sprite = await Sprite.load('jpg/bg_level.jpg');
    bg.size = size;
    await add(bg);

    btnSettings.sprite = await Sprite.load('png/btn_settings.png');
    btnSettings.onTap = showSettings;

    await add(targets);

    targets.init(targetConfig);

    // board = ;
    await add(board);
    board.position.y = targets.position.y + targets.scaledSize.y + 20;

    // board.init(targets);
    board.spawnNewGems();

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
    board.position = Vector2(size.x / 2 - board.scaledSize.x / 2, targets.position.y + targets.scaledSize.y + 20);
    super.onGameResize(size);
  }

  void showSettings() {
    popupSettings.show();
  }
}
