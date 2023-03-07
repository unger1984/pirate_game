import 'dart:math';

import 'package:flame/components.dart';
import 'package:get_it/get_it.dart';
import 'package:pirate/domain/datasources/audio_source.dart';
import 'package:pirate/presentation/components/main/gems/gem.dart';
import 'package:pirate/presentation/pirate_game.dart';
import 'package:pirate/presentation/screens/main_screen.dart';
import 'package:pirate/utils/const.dart';

class BoardComponent extends PositionComponent with HasGameRef<PirateGame> {
  final boardSize = Vector2(9, 7);
  final boardBack = <Vector2, SpriteComponent?>{};
  final boardFront = <Vector2, Gem?>{};
  final _random = Random();
  final _audio = GetIt.I<AudioSource>();
  final MainScreen screen;

  BoardComponent({required this.screen});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = Vector2(9 * Gem.gemSize.x, 7 * Gem.gemSize.y);
    position = gameRef.size / 2 - size / 2;

    await fillBg();

    var bg = boardBack[Vector2(5, 3)];
    if (bg != null) {
      remove(bg);
      boardBack.remove(Vector2(5, 3));
    }
    bg = boardBack[Vector2(4, 3)];
    if (bg != null) {
      remove(bg);
      boardBack.remove(Vector2(4, 3));
    }
    bg = boardBack[Vector2(3, 3)];
    if (bg != null) {
      remove(bg);
      boardBack.remove(Vector2(3, 3));
    }

    await fillEmpty();

    onGameResize(gameRef.size);
  }

  Future<void> spawnNewGems() async {
    bool needRefill = true;
    while (needRefill) {
      bool inverse = false;
      bool hasMoved = true;
      while (hasMoved) {
        hasMoved = await fillStep(inverse);
        inverse = !inverse;
      }
      var count = await clearAllValidMatches();
      needRefill = count > 0;
    }
    print(screen.targets.complete);
  }

  Future<void> fillBg() async {
    removeAll(children);
    boardBack.clear();
    final bg1Sprite = await Sprite.load('png/bg1.png');
    final bg2Sprite = await Sprite.load('png/bg2.png');

    var odd = false;
    for (double col = 0; col < boardSize.x; col++) {
      for (double row = 0; row < boardSize.y; row++) {
        final bg = SpriteComponent(sprite: odd ? bg1Sprite : bg2Sprite);
        bg.size = Gem.gemSize.clone();
        bg.position = Vector2(col * Gem.gemSize.x, row * Gem.gemSize.y);
        await add(bg);
        boardBack[Vector2(col, row)] = bg;
        odd = !odd;
      }
    }
  }

  Future<void> fillEmpty() async {
    for (var pos in boardBack.keys) {
      spawnGem(pos, GemType.empty);
    }
  }

  Future<void> moveGem(GemMovable gem, Vector2 pos) async {
    await gem.move(coordinate(pos));
    gem.pos = pos;
    boardFront[pos] = gem;
  }

  Future<bool> fillStep(bool inverse) async {
    bool hasMoved = false;
    final futures = <Future<void>>[];
    for (double row = boardSize.y - 2; row >= 0; row--) {
      for (double loopX = 0; loopX < boardSize.x; loopX++) {
        var col = inverse ? boardSize.x - 1 - loopX : loopX;

        final gem = boardFront[Vector2(col, row)];

        if (gem != null && gem is GemMovable) {
          final gemDown = boardFront[Vector2(col, row + 1)];
          final back = boardBack[Vector2(col, row + 1)];
          if (back != null && gemDown != null && gemDown.type == GemType.empty) {
            // Если гем под ним пустой
            remove(gemDown);
            futures.add(moveGem(gem, Vector2(col, row + 1)));
            futures.add(spawnGem(Vector2(col, row), GemType.empty));
            hasMoved = true;
          } else {
            for (double diag = -1; diag <= 1; diag++) {
              if (diag != 0) {
                double diagX = inverse ? col - diag : col + diag;

                if (diagX >= 0 && diagX < boardSize.x) {
                  final diagGem = boardFront[Vector2(diagX, row + 1)];
                  if (diagGem != null && diagGem.type == GemType.empty) {
                    bool hasGemAbove = true;
                    for (double aboveY = row; aboveY >= 0; aboveY--) {
                      final aboveGem = boardFront[Vector2(diagX, aboveY)];
                      if (aboveGem != null && aboveGem is GemMovable) {
                        break;
                      } else if (aboveGem == null && aboveGem is! GemMovable) {
                        hasGemAbove = false;
                        break;
                      }
                    }

                    if (!hasGemAbove) {
                      remove(diagGem);
                      futures.add(moveGem(gem, Vector2(diagX, row + 1)));
                      futures.add(spawnGem(Vector2(col, row), GemType.empty));
                      hasMoved = true;
                      break;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    await Future.wait(futures);

    // Верхний ряд
    for (double col = 0; col < boardSize.x; col++) {
      final gemBelow = boardFront[Vector2(col, 0)];
      if (gemBelow != null && gemBelow.type == GemType.empty) {
        remove(gemBelow);
        final gem = await spawnGem(Vector2(col, 0), GemType.colored);

        // gem.add(txt);
        // final gemTarget = coordinate(gem.pos);
        // gem.position += Vector2(0, -Gem.gemSize.y);
        // (gem as GemMovable).move(gemTarget);
        hasMoved = true;
      }
    }

    return hasMoved;
  }

  List<Gem> _findMatchHorisontal(GemColored gem, Vector2 newPos) {
    final result = <Gem>[];
    final color = gem.color;
    result.add(gem);
    for (double dir = 0; dir <= 1; dir++) {
      // Перебор по направлению налево и на право
      for (double xOffset = 1; xOffset < boardSize.x; xOffset++) {
        double col = dir == 0 ? newPos.x - xOffset : newPos.x + xOffset;

        if (col < 0 || col >= boardSize.x) {
          // вышли за границу экрана
          break;
        }

        final found = boardFront[Vector2(col, newPos.y)];
        if (found != null && found is GemColored && found.color == color) {
          // Найден гем и его цвет совпадает с искомым
          result.add(found);
        } else {
          break;
        }
      }
    }

    return result;
  }

  List<Gem> _findMatchVertical(GemColored gem, Vector2 newPos) {
    final result = <Gem>[];
    final color = gem.color;
    result.add(gem);
    for (double dir = 0; dir <= 1; dir++) {
      // Перебор по направлению налево и на право
      for (double yOffset = 1; yOffset < boardSize.y; yOffset++) {
        double row = dir == 0 ? newPos.y - yOffset : newPos.y + yOffset;

        if (row < 0 || row >= boardSize.y) {
          // вышли за границу экрана
          break;
        }

        final found = boardFront[Vector2(newPos.x, row)];
        if (found != null && found is GemColored && found.color == color) {
          // Найден гем и его цвет совпадает с искомым
          result.add(found);
        } else {
          break;
        }
      }
    }

    return result;
  }

  List<Gem>? findMatch(GemColored gem, Vector2 newPos) {
    List<Gem> horisontalGems = [];
    List<Gem> verticalGems = [];
    List<Gem> matchGems = [];

    // ищем по горизонтали
    horisontalGems = _findMatchHorisontal(gem, newPos);
    if (horisontalGems.length >= 3) {
      matchGems.addAll(horisontalGems);
      // для всех найденых ищем по вертикали
      for (int index = 0; index < horisontalGems.length; index++) {
        verticalGems = _findMatchVertical(gem, Vector2(horisontalGems[index].pos.x, newPos.y));
        if (verticalGems.length < 2) {
          verticalGems.clear();
        } else {
          matchGems.addAll(verticalGems);
        }
      }
    }

    if (matchGems.length >= 3) return matchGems;

    horisontalGems.clear();
    verticalGems.clear();
    verticalGems = _findMatchVertical(gem, newPos);

    if (verticalGems.length >= 3) {
      matchGems.addAll(verticalGems);
      for (int index = 0; index < verticalGems.length; index++) {
        horisontalGems = _findMatchHorisontal(gem, Vector2(newPos.x, verticalGems[index].pos.y));
        if (horisontalGems.length < 2) {
          horisontalGems.clear();
        } else {
          matchGems.addAll(horisontalGems);
        }
      }
    }

    if (matchGems.length >= 3) return matchGems;

    return null;
  }

  Future<int> clearAllValidMatches() async {
    int count = 0;
    bool isCollect = false;

    for (double row = 0; row < boardSize.y; row++) {
      for (double col = 0; col < boardSize.x; col++) {
        final gem = boardFront[Vector2(col, row)];
        final futures = <Future<void>>[];
        final cleared = <Gem>[];
        if (gem != null && gem is GemColored) {
          final match = findMatch(gem, Vector2(col, row));
          if (match != null) {
            for (int i = 0; i < match.length; i++) {
              if (!cleared.contains(match.elementAt(i))) {
                futures.add(clearGem(match.elementAt(i) as GemColored));
                cleared.add(match.elementAt(i));
                count++;
              }
            }
            await Future.wait(futures);
            cleared.clear();
            isCollect = true;
            if (isCollect) {
              await _audio.playSound('assets/audio/collect.mp3');
            }
          }
        }
      }
    }

    return count;
  }

  Future<bool> clearGem(GemColored gem) async {
    gem.priority = 0;
    Vector2 moveTo = Vector2(size.x / 2, -position.y + 200);
    final target = screen.targets;
    final color = gem.color.toString();
    final chest1 = target.chest1;
    final chest2 = target.chest2;
    final chest3 = target.chest3;

    if (color == chest1.gem) {
      moveTo = Vector2(chest1.position.x + chest1.size.x / 2, -position.y);
    } else if (color == chest2.gem) {
      moveTo = Vector2(chest2.position.x + chest2.size.x / 3, -position.y);
    } else if (color == chest3.gem) {
      moveTo = Vector2(chest3.position.x + chest3.size.x / 3, -position.y);
    }
    // gem.changeParent(screen);
    await gem.clear(moveTo, speed: 1500, duration: 0.8);
    if (color == chest1.gem) {
      chest1.addScore(1);
    } else if (color == chest2.gem) {
      chest2.addScore(1);
    } else if (color == chest3.gem) {
      chest3.addScore(1);
    }
    target.addScore(1);
    remove(gem);
    await spawnGem(gem.pos, GemType.empty);

    return true;
  }

  Future<Gem> spawnGem(Vector2 pos, GemType type) async {
    Gem gem;
    switch (type) {
      case GemType.empty:
        gem = GemEmpty();
        break;
      case GemType.colored:
        gem = GemColored(color: GemColor.values.elementAt(_random.nextInt(GemColor.values.length - 1)));
        break;
    }
    boardFront[pos] = gem;
    gem.pos = pos;
    gem.position = coordinate(pos);
    await add(gem);

    return gem;
  }

  Vector2 coordinate(Vector2 pos) {
    final bg = boardBack[pos];
    if (bg != null) {
      return bg.position;
    }

    return Vector2.zero();
  }

  @override
  void onGameResize(Vector2 size) {
    scale = Vector2.all(size.x / maxWidth);
    super.onGameResize(size);
  }
}
