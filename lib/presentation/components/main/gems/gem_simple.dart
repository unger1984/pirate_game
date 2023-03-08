import 'package:flame/experimental.dart';
import 'package:pirate/presentation/components/main/board_component.dart';
import 'package:pirate/presentation/components/main/gems/gem_clearable.dart';
import 'package:pirate/presentation/components/main/gems/gem_colored.dart';
import 'package:pirate/presentation/components/main/gems/gem_movable.dart';

class GemSimple extends GemColored with GemMovable, GemClerable, TapCallbacks, DragCallbacks {
  final BoardComponent board;

  GemSimple({required super.color, required this.board});

  @override
  void onTapUp(TapUpEvent event) {
    board.onTapGem(this);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final found = gameRef.componentsAtPoint(event.devicePosition).whereType<GemMovable>().toList();
    if (found.isNotEmpty && found.first != this) {
      board.onDragGem(this, found.first);
    }
  }
}
