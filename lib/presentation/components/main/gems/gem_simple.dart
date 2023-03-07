import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pirate/presentation/components/main/board_component.dart';
import 'package:pirate/presentation/components/main/gems/gem_clearable.dart';
import 'package:pirate/presentation/components/main/gems/gem_colored.dart';
import 'package:pirate/presentation/components/main/gems/gem_movable.dart';

class GemSimple extends GemColored with GemMovable, GemClerable, Tappable {
  final BoardComponent board;

  GemSimple({required super.color, required this.board});

  @override
  bool onTapUp(TapUpInfo info) {
    board.onTapGem(this);

    return false;
  }
}
