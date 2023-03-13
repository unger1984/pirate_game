import 'package:flame/components.dart';

class ProgressComponent extends SpriteComponent {
  late final double max;
  final SpriteComponent child;

  ProgressComponent({required Sprite sprite, required this.child}) : super(sprite: sprite) {}

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    max = child.size.x;
    child.position = size / 2 - child.size / 2;
    await add(child);
  }

  void setProgress(double progress) {
    // print(progress);
    child.size.x = progress > 100 ? max : progress * max / 100;
    // child.position = size / 2 - child.size / 2;
  }
}
