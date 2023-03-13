import 'package:flame/components.dart';
import 'package:pirate/domain/entities/target_chest_entity.dart';
import 'package:pirate/presentation/components/main/targets/bubble_component.dart';

enum ChestStatus {
  close('close'),
  open('open');

  final String _status;

  const ChestStatus(this._status);

  @override
  String toString() => _status;
}

enum ChestType {
  left('left'),
  right('right'),
  center('center');

  final String _type;

  const ChestType(this._type);

  @override
  String toString() => _type;
}

class ChestComponent extends PositionComponent {
  final ChestType type;
  ChestStatus status;
  final SpriteComponent chest = SpriteComponent();
  final BubbleComponent _bubble = BubbleComponent();
  late final Sprite _spriteClose;
  late final Sprite _spriteOpen;

  ChestComponent({required this.type, this.status = ChestStatus.open});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _spriteClose = await Sprite.load('png/targets/chest_close_$type.png');
    _spriteOpen = await Sprite.load('png/targets/chest_open_$type.png');

    chest.sprite = status == ChestStatus.open ? _spriteOpen : _spriteClose;
    chest.size = status == ChestStatus.open ? _spriteOpen.srcSize : _spriteClose.srcSize;

    _bubble.size = _bubble.size;
    await add(_bubble);

    size = Vector2(chest.size.x, _spriteOpen.srcSize.y + _bubble.size.y + 10);

    _bubble.position = Vector2(size.x / 2 - _bubble.size.x / 2, 0);
    chest.position = Vector2(size.x / 2 - chest.size.x / 2, size.y - chest.size.y);

    await add(chest);
  }

  set gem(String value) {
    _bubble.setGem(value);
  }

  String get gem => _bubble.gem;

  set target(int value) {
    _bubble.target = value;
  }

  void addScore(int value) {
    _bubble.addScore(value);
    if (current >= _bubble.target) {
      status = ChestStatus.close;
      chest.sprite = _spriteClose;
    }
  }

  int get current => _bubble.current;

  void init(TargetChestEntity target) {
    status = ChestStatus.open;
    chest.sprite = _spriteOpen;
    gem = target.gem;
    _bubble.sprite = _bubble.spriteBubbleOrange;
    _bubble.target = target.total;
  }
}
