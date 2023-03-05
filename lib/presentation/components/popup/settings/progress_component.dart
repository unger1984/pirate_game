import 'package:flame/components.dart';

class ProgressComponent extends SpriteComponent {
  late final double max;
  final SpriteComponent child;

  ProgressComponent({required Sprite sprite, required this.child}) : super(sprite: sprite) {
    max = child.size.x;
    child.position = size / 2 - child.size / 2;
    add(child);
  }

  void setProgress(double progress) {
    child.size.x = progress > 100 ? max : progress * max / 100;
  }
}
