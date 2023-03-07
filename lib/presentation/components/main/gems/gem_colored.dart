import 'package:flame/components.dart';
import 'package:pirate/presentation/components/main/gems/gem.dart';

abstract class GemColored extends Gem {
  final GemColor color;

  GemColored({required this.color}) : super(type: GemType.colored);

  @override
  Future<void> onLoad() async {
    final sprite = await Sprite.load('png/gems/$color.png');
    final fg = SpriteComponent(sprite: sprite);

    await add(fg);

    await super.onLoad();
  }
}
