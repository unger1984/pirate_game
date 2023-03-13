import 'package:flame/components.dart';
import 'package:pirate/domain/entities/target_entity.dart';
import 'package:pirate/presentation/components/common/button_component.dart';
import 'package:pirate/presentation/components/main/board_component.dart';
import 'package:pirate/presentation/components/main/targets_component.dart';
import 'package:pirate/presentation/components/popup/overlay_component.dart';
import 'package:pirate/presentation/components/popup/popup_completed_component.dart';
import 'package:pirate/presentation/components/popup/popup_settings_component.dart';
import 'package:pirate/presentation/pirate_game.dart';
import 'package:pirate/utils/const.dart';

class MainScreen extends PositionComponent with HasGameRef<PirateGame> {
  final overlay = OverlayComponent();
  final popupSettings = PopupSettingsComponent();
  final popupCompleted = PopupCompletedComponent();
  final bg = SpriteComponent();
  final btnSettings = ButtonComponent(withScale: true);
  late final BoardComponent board = BoardComponent(screen: this);
  late final TargetsComponent targets = TargetsComponent(screen: this);
  late TargetEntity _targetConfig;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = gameRef.size;

    bg.sprite = await Sprite.load('jpg/bg_level.jpg');
    bg.size = size;
    await add(bg);

    btnSettings.sprite = await Sprite.load('png/ui/btn_settings.png');
    btnSettings.onTap = showSettings;

    await add(targets);
    // targets.init(targetConfig);

    // board = ;
    await add(board);
    board.position.y = targets.position.y + targets.scaledSize.y + 20;

    await add(btnSettings);

    await add(popupCompleted);
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

  void setLevel(TargetEntity targetConfig) {
    _targetConfig = targetConfig;
    targets.init(_targetConfig);
    board.fillOnStart();
  }

  Future<void> restart() async {
    await popupCompleted.hide();
    targets.init(_targetConfig);
    board.fillOnStart();
  }

  void endLimit() {
    board.isEndLevel = true;
  }

  void showResult(bool win) {
    popupCompleted.setResult(win, 1, targets.stats.score, targets.stats.stars);
    _showCompleted();
  }

  Future<void> showSettings() async {
    await popupSettings.show();
  }

  Future<void> _showCompleted() async {
    await popupCompleted.show();
  }
}
