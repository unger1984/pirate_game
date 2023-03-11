import 'package:flame/components.dart';
import 'package:pirate/presentation/components/map/point_component.dart';

enum LevelStatus {
  close('close'),
  open('open'),
  done('done');

  final String _status;

  const LevelStatus(this._status);

  @override
  String toString() => _status;
}

class LevelComponent extends PositionComponent {
  final point = PointComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = point.size;
    await add(point);
  }

  set onTap(void Function(int) callback) {
    point.onTap = callback;
  }

  void setActive() {
    point.setStatus(LevelStatus.open);
  }

  void setDone(int starts) {
    point.setStatus(LevelStatus.done);
    point.setStar(starts);
  }

  void init(int num, [LevelStatus status = LevelStatus.close, int starts = 0]) {
    point.setNum(num);
    point.setStatus(status);
    point.setStar(starts);
  }
}
